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

# Docker helpers

```sh
dck sh | bash | list |stopall |cleanimages |cleancontainers | ui | registry | inspect <container name> <jq filter>
```

# Need to use Ruby?  Multiple ruby version support via chruby, if detected.

```sh
# DETECT CHRUBY support 

if [[ -d /usr/local/share/chruby/ ]]; then
        # Linux installation of chruby
        chruby_path=/usr/local/share/chruby/
elif [[ -d /usr/local/opt/chruby/share/chruby/ ]]; then 
        # Homebrew installation of chruby
        chruby_path=/usr/local/opt/chruby/share/chruby/
fi

if [[ -d $chruby_path ]]; then
        source $chruby_path/chruby.sh
        source $chruby_path/auto.sh
fi
```


# Working in multi-window tmux environment ?

If detected, `onproject <name>` , `offproject` shortcuts to launch project specific setup

```sh
if [[ -f /usr/bin/tmux ]]; then

if [[ -d /mnt/c/Windows/ ]]; then
# Holy shit, I am on windows linux subsystem

function onproject() {
  TMUXMODE=$2 tmuxinator ${1}_env
}

else

function onproject() {
  TMUXMODE=$2 gnome-terminal -x tmuxinator ${1}_env &
}

fi

function offproject() { 
  tmux kill-session -t ${1} &
}

autoload -Uz onproject
autoload -Uz offproject

alias killproject='tmux kill-server'

fi
```


# Folder specific environment

If you have direnv tool installed, `.envrc` start to get supported.

```
if [[ -f /usr/bin/direnv ]]; then
# direnv
eval "$(direnv hook zsh)"
fi
```



# Gitflow fun?

For simple pet projects handy shortcuts for easy process enforcing.

```sh
if [[ -f ~/dotfiles/gitflow/release_start.sh ]]; then

# gitflow
alias gitflow-init='git flow init -f -d'
alias gitflow-release-start='~/dotfiles/gitflow/release_start.sh'
alias gitflow-release-finish='~/dotfiles/gitflow/release_finish.sh'
alias gitflow-hotfix-start='~/dotfiles/gitflow/hotfix_start.sh'
alias gitflow-hotfix-finish='~/dotfiles/gitflow/hotfix_finish.sh'

fi
```

# NodeJS development?

If detected, nvm is loaded and per project `.nvmrc` is supported to switch node version in console.

```sh
if [[ -f ~/.nvm/nvm.sh ]]; then

source ~/.nvm/nvm.sh

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then 
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

fi
```



# Python development ?

If detected, your virtual envs are carefully stored in ~/.virtualenvs

```sh
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then

mkdir -p ~/.virtualenvs
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

fi
```

Additional shell prompt hint/coloring for virtualenv:

~/.virtualenvs/postactivate

```sh
#!/usr/bin/zsh
# This hook is sourced after every virtualenv is activated.

PS1="$_OLD_VIRTUAL_PS1"
_OLD_RPROMPT="$RPROMPT"
RPROMPT="%{${fg_bold[white]}%}(pyenv: %{${fg[green]}%}`basename \"$VIRTUAL_ENV\"`%{${fg_bold[white]}%})%{${reset_color}%} $RPROMPT"

```

~/.virtualenvs/postdeactivate
```sh

#!/usr/bin/zsh
# This hook is sourced after every virtualenv is deactivated.

RPROMPT="$_OLD_RPROMPT"

```



# Project notes

Are you using  notebook for taking notes? If detected - `znotes` shortcut added.

```sh
if [[ -d ~/.virtualenvs/project_notes ]]; then

alias znotes='workon project_notes && cd ${ZNOTES_PATH-~/z_personal_notes} && jupyter lab'

fi
```



# Windows syntethic sugar

alias 'startdot'='xdg-open .'

# Anything locally specific?

Add .zshrc.local - it gets parsed.

```sh
if [[ -f ${HOME}/.zshrc.local ]]; then source ${HOME}/.zshrc.local; fi
```


# Time to sleep

Done with work? Handy shortcut.

```sh
alias 'nah'='echo "shutdown (ctrl-c to abort)?" && read && sudo shutdown 0'
```
