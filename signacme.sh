#!/bin/bash

DEBUG=true
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

if [ ! -d "./$DOMAIN" ]; then
	mkdir ./$DOMAIN
fi

if [ ! -f "./$DOMAIN/domain.key" ]; then
	openssl genrsa 4096 > ./$DOMAIN/domain.key
fi

if [ ! -f "./$DOMAIN/domain.csr" ]; then
	openssl req -new -sha256 -key ./$DOMAIN/domain.key -subj "/CN=$DOMAIN" > ./$DOMAIN/domain.csr
fi

python $ROOTDIR/acme_tiny.py --ca $CA --account-key $ROOTDIR/account.key --csr $ROOTDIR/$DOMAIN/domain.csr --acme-dir /var/www/challenges/ > $ROOTDIR/$DOMAIN/signed.crt
wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > /tmp/intermediate.pem
cat $ROOTDIR/$DOMAIN/signed.crt /tmp/intermediate.pem > $ROOTDIR/$DOMAIN/chained.pem
rm /tmp/intermediate.pem

echo "Put the following in your nginx domain configuration"
echo "----------------------------------------------------"
echo "ssl on;"
echo "ssl_certificate $ROOTDIR/$DOMAIN/chained.pem;"
echo "ssl_certificate_key $ROOTDIR/$DOMAIN/domain.key;"
echo "ssl_session_timeout 5m;"
echo "ssl_protocols TLSv1 TLSv1.1 TLSv1.2;"
echo "ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA;"
echo "ssl_session_cache shared:SSL:50m;"
echo "ssl_dhparam $ROOTDIR/dhparam.pem;"
echo "ssl_prefer_server_ciphers on;"


