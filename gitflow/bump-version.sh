#!/bin/bash

set -e

CURRENT_DIR=`pwd`
VERSION=$1

if [ ! -d ".git" ]; then
  cd $(git rev-parse --show-cdup)
fi

if [ -f "$CURRENT_DIR/galaxy.yml" ]; then
echo detected $CURRENT_DIR/galaxy.yml
echo "s/version:[[:space:]]*.*/version: $VERSION/g" $CURRENT_DIR/galaxy.yml
sed -i.bak "s/version:[[:space:]]*.*/version: $VERSION/g" $CURRENT_DIR/galaxy.yml
fi

echo $VERSION > version.txt
