#!/bin/sh

# curl -sSL http://bit.ly/slavkodotfiles > bootstrap.sh && chmod +x bootstrap.sh
# ./bootstrap.sh
 
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

curl -sSL https://raw.githubusercontent.com/Voronenko/dotfiles/master/dotfiles_rsa > ./dotfiles_id_rsa && chmod 600 ./dotfiles_rsa
ssh-add ./dotfiles_rsa; git clone git@github.com:Voronenko/dotfiles.git; ssh-add -d ./dotfiles_rsa;
rm ./dotfiles_rsa


curl -sSL https://raw.githubusercontent.com/Voronenko/ansible-developer_recipes/master/recipes_id_rsa > ./recipes_rsa && chmod 600 ./recipes_rsa
ssh-add ./recipes_rsa; git clone git@github.com:Voronenko/ansible-developer_recipes.git; ssh-add -d ./recipes_rsa;
rm ./recipes_rsa


cd dotfiles

./init.sh
