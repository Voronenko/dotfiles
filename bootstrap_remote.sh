#!/bin/bash

# curl -sSL http://bit.ly/getmyshell > getmyshell.sh && chmod +x getmyshell.sh && ./getmyshell.sh

if [ -e /usr/bin/yum ]
then
    pkgmanager=yum
elif [ -e /usr/bin/apt ]
then
    pkgmanager=apt-get
else
    echo "No supported package manager"
    exit 1
fi

sudo $pkgmanager -y install curl make

curl -sSL https://raw.githubusercontent.com/Voronenko/dotfiles/master/bootstrap.sh > ~/bootstrap.sh
curl -sSL https://raw.githubusercontent.com/Voronenko/dotfiles/master/bashrc > ~/.bashrc
curl -sSL https://raw.githubusercontent.com/Voronenko/dotfiles/master/zshrc > ~/.zshrc
touch ~/.zshrc.local
touch ~/bashrc.local
chmod +x ~/bootstrap.sh
