#!/bin/bash


## set correct git config certificates
if [[ -z "${REQUESTS_CA_BUNDLE}" ]]  
then
    cert_file="${PREFIX}/ssl/cacert.pem"
else
    cert_file="${REQUESTS_CA_BUNDLE}"
fi

git config --system http.sslVerify true
git config --system http.sslCAPath "${cert_file}"
git config --system http.sslCAInfo "${cert_file}"
