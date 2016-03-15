#!/bin/bash

ROOTDIR="/root/certificates"
DOMAIN="$1"

python $ROOTDIR/acme_tiny.py --account-key $ROOTDIR/account.key --csr $ROOTDIR/$DOMAIN/domain.csr --acme-dir /var/www/challenges/ > /tmp/signed.crt || exit
wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > /tmp/intermediate.pem
cat /tmp/signed.crt /tmp/intermediate.pem > $ROOTDIR/$DOMAIN/chained.pem
service nginx reload
rm /tmp/signed.crt
rm /tmp/intermediate.pem
