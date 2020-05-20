#!/bin/bash

# $1 - string to find
# $2 - branch name or nothing (current branch in that case)

# ~/dotfiles/gitflow/findFilesContainingStringInBranch.sh "my_password" master

git log -S "$1" $2 --name-only --pretty=format: -- | sort -u
