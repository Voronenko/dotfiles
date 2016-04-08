dotfiles
========

My unix environment

So, to recap, the install script will:

* Back up any existing dotfiles in your home directory to ~/dotfiles_old/
* Create symlinks to the dotfiles in ~/dotfiles/ in your home directory
* Clone the oh-my-zsh repository from my GitHub (for use with zsh)
* Check to see if zsh is installed, if it isn't, try to install it.
* If zsh is installed, run a chsh -s to set it as the default shell.


# Folder specific SSH identity for git

see ssh-ident conf file for examples


# Folder specific environment

See plugin
https://github.com/Tarrasch/zsh-autoenv
