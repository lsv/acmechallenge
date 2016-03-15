#!/bin/bash

ROOTDIR="/root/certificates"
DOMAIN="$1"

DEBUG_CERTIFICATE="https://acme-staging.api.letsencrypt.org"
CERTIFICATE="https://acme-v01.api.letsencrypt.org"
CA=$CERTIFICATE

if [ -z "$1" ]; then
        echo "No domains supplied"
        exit;
fi

if [ ! -z "$2" ]; then
        echo "Using staging";
        CA=$DEBUG_CERTIFICATE;
fi

python $ROOTDIR/acme_tiny.py --ca $CA --account-key $ROOTDIR/account.key --csr $ROOTDIR/$DOMAIN/domain.csr --acme-dir /var/www/challenges/ > /tmp/signed.crt || exit
wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > /tmp/intermediate.pem
cat /tmp/signed.crt /tmp/intermediate.pem > $ROOTDIR/$DOMAIN/chained.pem
service nginx reload
rm /tmp/signed.crt
rm /tmp/intermediate.pem
