#!/bin/sh

mkdir -p ~/.aws/cli
mv ~/.aws/cli/alias ~/.aws/cli/alias.old || true
ln -s $PWD/alias ~/.aws/cli/alias

