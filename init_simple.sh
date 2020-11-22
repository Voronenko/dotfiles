#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

preferred_shell=${1:-DEFAULT}
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc gitconfig oh-my-zsh nanorc ruby-version selected_editor vimrc zshrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir :"
for file in $files; do
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

install_zsh () {
echo "Test to see if zshell is installed.  If it is:"
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then

    echo keyscan github.com
    touch ~/.ssh/known_hosts
    ssh-keyscan -t rsa,dsa github.com 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts
    mv ~/.ssh/tmp_hosts ~/.ssh/known_hosts

    echo "Clone my oh-my-zsh repository from GitHub only if it isn't already present"
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git
    fi
    echo "Set the default shell to zsh if it isn't currently set to zsh"
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        sudo chsh -s $(which zsh) $USER
        echo "Shell changed ; will be available after reboot (sudo shutdown -r 0)"
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh -y
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}


if [ "${preferred_shell}" = "zsh" ]; then

  install_zsh

else

  echo "Clone my oh-my-zsh repository from GitHub only if it isn't already present"
  echo "In case if in the future you would like to use zsh :)"
  if [[ ! -d $dir/oh-my-zsh/ ]]; then
      git clone https://github.com/robbyrussell/oh-my-zsh.git
  fi

fi
