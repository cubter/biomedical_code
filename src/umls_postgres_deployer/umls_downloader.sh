#!/bin/bash

# 1. Add your API key from https://uts.nlm.nih.gov/uts/profile
# 2. Run the script (for example: bash umls_download.sh https://download.nlm.nih.gov/umls/kss/rxnorm/RxNorm_weekly_current.zip)

export DOWNLOAD_URL=https://download.nlm.nih.gov/umls/kss/2021AB/umls-2021AB-full.zip
read -rp "API key: " apikey

export CAS_LOGIN_URL=https://utslogin.nlm.nih.gov/cas/v1/api-key

if [ -z "$apikey" ]; then 
    echo "Please enter you api key."
    exit
fi

TGT=$(curl --tlsv1.2 -d "apikey="$apikey -H "Content-Type: application/x-www-form-urlencoded" -X POST https://utslogin.nlm.nih.gov/cas/v1/api-key)

TGTTICKET=$(echo $TGT | tr "=" "\n")

for TICKET in $TGTTICKET
do
    if [[ "$TICKET" == *"TGT"* ]]; then
        SUBSTRING=$(echo $TICKET | cut -d'/' -f 7)
        TGTVALUE=$(echo $SUBSTRING | sed 's/.$//')
	fi
done

echo $TGTVALUE 

STTICKET=$(curl --tlsv1.2 -d "service="$DOWNLOAD_URL -H "Content-Type: application/x-www-form-urlencoded" -X POST https://utslogin.nlm.nih.gov/cas/v1/tickets/$TGTVALUE)

echo $STTICKET

curl -c cookie.txt -b cookie.txt -L -O -J $DOWNLOAD_URL?ticket=$STTICKET
rm cookie.txt


