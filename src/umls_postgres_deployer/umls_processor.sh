#! /bin/bash

read -rp "Do you want to check if the UMLS arhive has been updated and download it (yes/no)?" to_download

if [[ $to_download == "yes" ]]; then
    bash umls_downloader.sh
elif [[ $to_download != "no" ]]; then
    echo "Wrong answer, should be \"yes\" not \"no\". Aborting."
fi

echo "Extracting UMLS archives, please wait..." 

unzip $(ls | grep umls_metathes) -d umls_meta_files -x "*indexes*" -x "*CHANGE*" -x "*.ctl" -x "*.txt" -x "*.sql" -x "*.bat*" -x "*.sh*" -x "*.x" -x "*.dat" 

cd "umls_meta_files/$(ls umls_meta_files | grep 202)/META"

echo -e "\nSplitting large files, please, wait..."

table_names=()
i=0

mkdir processed_files_for_postgres

for file in *
do
    if [[ $file != *\.RRF ]]; then
        continue
    fi

    table_name=$(echo $file | sed 's\.RRF\\g')
    
    table_names[i]=$table_name
    ((i++))
    
    # Checking if the file's size exceeds 1.9 Gb and splitting it on chunks with each being eq.
    # 8 million rows; copying the split files into the subdirectory afterwards 
    size=$(du -sh -b $file | awk '{ print $1 }')
    if [ $size -gt 1900000000 ]; then
        split -l 8000000 --additional-suffix=".RRF" $file processed_files_for_postgres/$table_name
        echo "$file split."
        
        rm $file
        continue
    fi
    
    cp $file processed_files_for_postgres
    rm $file
done


# Generating table creating scripts for each file
for tbl in ${table_names[@]}
do
    colnames_ord=$(cat processed_files_for_postgres/MRFILES.RRF | grep $tbl | awk -F "|" '{ print $3}' | awk -F "," \
    '{  
        for (i=0; ++i<=NF; ) 
            print $i
    }')
    
    colnames_ord_arr=( $colnames_ord )

    colnames=$(cat processed_files_for_postgres/MRCOLS.RRF | grep $tbl | awk -F "|" '{ print $1 }')
    types=$(cat processed_files_for_postgres/MRCOLS.RRF | grep $tbl | awk -F "|" '{ print $8 }')
    
    colnames_arr=( $colnames )

    # Replacing UMLS-specified types. Some tables' cells exceed the 
    # sizes of the types' specified in MRCOLS.RRF, hence need for the replacement 
    declare -A types_arr
    
    i=0
    for type in $types
    do
        if [[ $type == "varchar("* ]]; then 
            type=varchar
        elif [[ $type == integer ]]; then
            type=bigint
        fi
        
        col_key=${colnames_arr[$i]}
        types_arr[$col_key]=$type
        
        ((i++))
    done
    
    # Generating the query for table creation  
    len=${#colnames_ord_arr[@]}
    subq="DROP TABLE IF EXISTS umls.$tbl;\n"  
    subq+="CREATE TABLE umls.$tbl(\n"
    
    i=0
    while [ $i -lt $len ]
    do
        col=${colnames_ord_arr[$i]}
        
        subq+="\t$col ${types_arr[$col]},\n"
        
        if [ $i == $(($len - 1)) ]; then
            subq+="\tdummy char(1)\n"
        fi
        
        ((i++))
    done
    
    subq+=");\n"
    # Unlogged mode to pace the data upload. "Unlogged" prevents writing to WAL.
    subq+="ALTER TABLE umls.$tbl SET UNLOGGED;" 
    echo -e $subq >> create_tables.sql
    
    # To restore the logged mode later, after uploading
    echo "ALTER TABLE umls.$tbl SET LOGGED;" >> restore_logged.sql                
    echo "ALTER TABLE umls.$tbl DROP COLUMN DUMMY;" >> remove_dummy.sql       
done


##########  Uploading files to Postgres  ##########

echo -e "\nConnecting to Postgres.\n"

pg_user=$(cat "../../../database_cred.txt" | grep username  | sed -E 's/(username:\s{1,}|\s|\t)//g')
pg_db=$(cat "../../../database_cred.txt"   | grep db_name   | sed -E 's/(db_name:\s{1,}|\s|\t)//g')
db_ip=$(cat "../../../database_cred.txt"   | grep host_addr | sed -E 's/(host_addr:\s{1,}|\s|\t)//g')
read -rsp "Postgres password: " pg_pass

PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -c "create schema if not exists umls;"
PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f create_tables.sql

echo -e "\nTables created."
echo -e "Loading data. This will take a while. Go grab a cup of coffee or tea (few cups actually)...\n"

for file in $(ls processed_files_for_postgres)
do 
    for tbl in ${table_names[@]}
    do
        if [[ $file == $tbl* ]]; then    
            PGPASSWORD=$pg_pass psql -b -h $db_ip -U $pg_user -d $pg_db -c \
            "\copy umls.$tbl from 'processed_files_for_postgres/$file' with csv escape as E'\001' quote as E'\031' delimiter AS '|' null AS '' encoding 'UTF-8' autovacuum_enabled=false;" > "../../../copy.log"
        fi
    done
done

echo -e "\nCopying tables accomlished. Watch at the copy.log for errors & notices."

PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f restore_logged.sql
PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f remove_dummy.sql

rm restore_logged.sql create_tables.sql remove_dummy.sql

##########  Creating comments  ##########

echo -e "Creating comments on columns & tables...\n"

# Getting table comments
echo "SELECT subq.comment FROM
(SELECT 
    'COMMENT ON TABLE umls.'
    ||  LOWER(REPLACE(REPLACE(f.fil,'CHANGE/',''),'.RRF',''))
    || ' IS ''' 
    || f.des 
    || ''';'
    as comment,
    f.fil, f.des, f.fmt, f.cls, f.rws, f.bts 
FROM
    umls.mrfiles f
ORDER BY f.fil) as subq" > get_comments.sql

# Removes the number of rows and the -----comment----- section from the obtained comments;
# adds comments.
PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f get_comments.sql | \
sed -E 's\comment|-{1,}\\g' | \
sed -E 's/\(\w{1,}\s\w{1,}\)//g' \
> create_comments.sql

# Getting column comments
echo "SELECT subq.comment FROM
(SELECT 
    'COMMENT ON COLUMN umls.' 
    ||  LOWER(REPLACE(REPLACE(c.fil,'CHANGE/',''),'.RRF','')) 
    || '.'
    || c.col
    || ' IS ''' 
    || c.des 
    || ''';' as comment,
    c.REF,
    c.min,
    c.max,
    c.fil,
    c.dty,
    c.des,
    c.col,
    c.av
FROM
    umls.mrcols c
ORDER BY c.fil) as subq" > get_comments.sql

PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f get_comments.sql | \
sed -E 's\comment|-{1,}\\g' | \
sed -E 's/\(\w{1,}\s\w{1,}\)//g' \
>> create_comments.sql

PGPASSWORD=$pg_pass psql -b -h $db_ip -U $pg_user -d $pg_db -f create_comments.sql > "../../../comments.log"

echo -e "\nCompleted creating comments. Watch at the comments.log for errors & notices."

rm get_comments.sql create_comments.sql


################  Creating indices  ################

echo -e "\nCreating indices. Please, wait..."
PGPASSWORD=$pg_pass psql -h $db_ip -U $pg_user -d $pg_db -f "../../../create_indices_and_constraints.sql" > "../../../indices.log"

echo -e "\nCompleted constructing indices. Watch at the indices.log for errors & notices."
echo "Removing unzipped files."

rm -rf umls_meta_files

