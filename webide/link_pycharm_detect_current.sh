#!/bin/bash

unset -v IDEVERSIONRAW
for file in ~/.PyCharm*; do
  [[ $file -nt $IDEVERSIONRAW ]] && IDEVERSIONRAW=$file
done

IDEVERSION=`basename $IDEVERSIONRAW`
export PYCHARMVERSION=${IDEVERSION:1:${#IDEVERSION}-1}
./link_pycharm.sh
