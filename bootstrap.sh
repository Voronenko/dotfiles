#!/bin/bash

# curl -sSL http://bit.ly/slavkodotfiles > bootstrap.sh && chmod +x bootstrap.sh
# ./bootstrap.sh


if [ "$(id -u)" == "0" ]; then
echo "Installation must NOT be done under sudo"
echo "use your regular user account"
exit 1
fi

sudo apt-get -y install git curl

SUDOERUSER="$(whoami)"
SUDOERFILE="/etc/sudoers.d/$SUDOERUSER"

sudo bash -c "touch $SUDOERFILE"
sudo bash -c "echo $SUDOERUSER ALL=\(ALL\) NOPASSWD: ALL > $SUDOERFILE"

sudo apt-get -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible

echo "===================================================================="
echo "current user was added to SUDOERS w/o password"
echo "don't  forget to remove settings after initial box configuration"
echo "by removing file $SUDOERFILE"

curl -sSL https://raw.githubusercontent.com/Voronenko/dotfiles/master/dotfiles_rsa > ./dotfiles_rsa && chmod 600 ./dotfiles_rsa
ssh-add ./dotfiles_rsa; git clone git@github.com:Voronenko/dotfiles.git;
rm ./dotfiles_rsa


curl -sSL https://raw.githubusercontent.com/Voronenko/ansible-developer_recipes/master/recipes_rsa > ./recipes_rsa && chmod 600 ./recipes_rsa
ssh-add ./recipes_rsa; git clone git@github.com:Voronenko/ansible-developer_recipes.git;
rm ./recipes_rsa

cd dotfiles

./init.sh
