#!/bin/sh
 
sudo apt-get install git

echo "current user to SUDOERS w/o password"
echo "don't  forget to remove settings after initial box configuration"
 
 
#! /bin/bash
PATTERN="$ a\
$(whoami) ALL=\(ALL\) NOPASSWD: ALL
"
# with backup
sudo sed -i.bak -e "$PATTERN" /etc/sudoers
 
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
 
git clone git@github.com:Voronenko/dotfiles.git
 
git clone git@github.com:Voronenko/ansible-developer_recipes.git

cd dotfiles

./init.sh
