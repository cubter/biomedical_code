## Summary
This file describes how to download, process and upload UMLS files to a Postgres DB but also how to work with 
this directory. 

*You should only execute `umls_processor.sh` script, there's no need to launch `umls_downloader`.*

## Database access
All the database credentials (EXCEPT PASSWORD) MUST be stored in the `database_cred.txt` file, so just add them after the colons. Again: DO NOT STORE THE PASSWORD in the `database_cred.txt`, since it's a very bad practice, and `umls_downloader.sh` will ask you for the password anyway. 

## Files and formats
There's also the `create_indices_and_constraints.sql` file with indices for the tables. IT IS NOT UPDATED AUTOMATICALLY IN ANY WAY AND IT'S UP TO YOU TO DO IT.

## Downloading, processing & uploading to Postgres

You should only execute `umls_processor.sh` script, there's no need to launch umls_downloader by hand.
```
bash umls_processor.sh
```

The script will authorise you with the UMLS, download all the required files, unzip them, perform some checks, deploy them to your Postgres DB and create comments and indices. Since the process includes downloading and deploying to Postgres, it will take a while (expect several hours). 

**In order to download the UMLS files, ONE NEEDS A VALID UMLS API KEY.**

## Credits
`umls_downloader.sh` is provided by the UMLS itself and can be downloaded from their website. So I only needed to create the `umls_processor.sh`. 
