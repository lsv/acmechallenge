#!/bin/bash

STAGING=false

if [ ! -z "$1" ]; then
        STAGING=true;
fi

for FILE in `ls -l`
do
    if [ -d $FILE ]; then
	if [ "$STAGING" = true ]; then
		./renew.sh $FILE true
	else
		./renew.sh $FILE
	fi
    fi
done
