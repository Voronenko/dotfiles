#!/bin/bash
# $1 - branch
# $2 - string to find
# $3 - string to replace with

# ~/replaceStringInBranch.sh master "my_password" "********"

git checkout $1
for file in $(~/dotfiles/gitflow/findFilesContainingStringInBranch.sh "$2"); do
  echo "          Filtering file $file:"
  ~/dotfiles/gitflow/changeStringsInFileInCurrentBranch.sh "$file" "$2" "$3"
done
