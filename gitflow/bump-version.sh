#!/bin/bash

set -e

CURRENT_DIR=`pwd`
VERSION=$1

if [ ! -d ".git" ]; then
  cd $(git rev-parse --show-cdup)
fi

echo $VERSION > version.txt


