#!/bin/bash

set -e

CURRENT_DIR=`pwd`
VERSION=$1

cd $(git rev-parse --show-cdup)

echo $VERSION > version.txt


