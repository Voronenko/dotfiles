#!/bin/bash

# $1 - file name
# $2 - string to find
# $3 - string to replace

# ~/dotfiles/gitflow/changeStringsInFileInCurrentBranch.sh "abc.txt" "my_password" "********"

git filter-branch -f --tree-filter "if [ -f $1 ];then sed -i s/$2/$3/g $1;fi"
