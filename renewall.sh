#!/bin/bash

for FILE in `ls -l`
do
    if test -d $FILE
    then
      ./renew.sh $FILE
    fi
done
