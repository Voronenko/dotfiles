#!/bin/bash
# https://httpd.apache.org/docs/2.2/misc/password_encryptions.html

HTPASSWD=$1
USERNAME=$2
PASSWORD=$3

ENTRY=`cat $HTPASSWD | grep "^$USERNAME:"`
HASH=`echo $ENTRY | cut -f 2 -d :`
SALT=`echo $HASH | cut -f 3 -d $`
RESULT=`openssl passwd -apr1 -salt $SALT $PASSWORD`

echo "File: $HTPASSWD"
echo "Username: $USERNAME"
echo "Entry: $ENTRY"
echo "Hash: $HASH"
echo "Salt: $SALT"

echo "password to check: $PASSWORD"
echo "openssl result: $RESULT"

if [ $RESULT = $HASH ]
then
  echo "OKAY"
else
  echo "NOT MATCHED"
fi
