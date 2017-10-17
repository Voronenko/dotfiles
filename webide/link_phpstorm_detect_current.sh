#!/bin/bash

unset -v IDEVERSIONRAW
for file in ~/.PhpStorm*; do
  [[ $file -nt $IDEVERSIONRAW ]] && IDEVERSIONRAW=$file
done

IDEVERSION=`basename $IDEVERSIONRAW`
export PHPSTORMVERSION=${IDEVERSION:1:${#WEBIDEVERSION}-1}
./link_phpstorm.sh
