#!/bin/sh

VERSION=$1
if [ -z $1 ]
then
  VERSION=`~/dotfiles/gitflow/bump-minorversion-drynext.sh`
fi

if [ ! -d ".git" ]; then
  cd $(git rev-parse --show-cdup)
fi

#Initialize gitflow
git flow init -f -d

# ensure you are on latest develop  & master
git checkout develop
git pull origin develop
git checkout -

git checkout master
git pull origin master
git checkout develop

git flow hotfix start $VERSION

NEXTVERSION=`~/dotfiles/gitflow/bump-minorversion-drynext.sh`
~/dotfiles/gitflow/bump-version.sh $NEXTVERSION
git commit -am "Bumps version to $NEXTVERSION"

# bump hotfix version to server
git push

