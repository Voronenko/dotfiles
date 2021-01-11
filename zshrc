# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

### Do we run interactively?
[[ $- != *i* ]] && return

### Do we profile ?

# Credit: https://kev.inburke.com/kevin/profiling-zsh-startup-time/

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof # Output load-time statistics
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/tmp}/zsh_statup.$$"
    setopt xtrace prompt_subst
fi


###
#CONFIG

KUBE_PS1_ENABLED=off #use kubeon when working with kubernetes
KUBE_PS1_SYMBOL_USE_IMG=true
KUBE_PS1_NS_ENABLE=true
KUBE_PS1_DIVIDER='/'

POWERLEVEL9K_MODE='awesome-fontconfig' # compatible | awesome-fontconfig | nerdfont-complete
POWERLEVEL9K_SPACELESS_PROMPT_ELEMENTS=(dot_dir)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dot_dir_ex dot_git dot_status mybr) #icons_test
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv go_version aws dot_ssh dot_dck dot_toggl dot_terraform dot_jenv custom_kube_ps1)

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=""
POWERLEVEL9K_CUSTOM_KUBE_PS1='kube_ps1'

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

##

# async prompt helpers
#source ${HOME}/dotfiles/helpers/dotfiles_async.zsh


# completion sugar
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit -i

if [ -f /.dockerenv ]; then
    ZSH_IN_DOCKER=true
fi


# custom completion scripts
fpath=($HOME/dotfiles/completions $fpath)

# params block

# /params block
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"
if [[ -d /mnt/c/Windows/ ]]; then
ZSH_DISABLE_COMPFIX=true
fi

# notifications
bgnotify_threshold=4  ## set your own notification threshold

function notify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && title="Completed" || title="Failure"
  bgnotify "$title -- after $3 s" "$2";
}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(composer docker-compose kubectl kubetail fzf-zsh bgnotify alias-tips pipenv)

source $ZSH/oh-my-zsh.sh
#if type "kubectll" > /dev/null; then # TODO: if kubectl is absent skip
source ${HOME}/dotfiles/bin/kube-ps1.sh
#fi

# User configuration

export PATH=${HOME}/dotfiles/bin:$HOME/.jenv/bin:$HOME/.local/bin:/usr/local/bin:$HOME/config/composer/vendor/bin:$PATH:${KREW_ROOT:-$HOME/.krew}/bin
export IBUS_ENABLE_SYNC_MODE=1 # JetBrains issues with IBus prior 1.5.11
export DISABLE_AUTO_TITLE='true'

zstyle ':completion:*:*:git:*' script ~/.git-completion.zsh

# export MANPATH="/usr/local/man:$MANPATH"

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

# # Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nano'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

alias pps='ps -eo uname:20,pid,pcpu,pmem,sz,tty,stat,time,cmd'

if [[ -f /usr/bin/tmux ]]; then

if [[ -d /mnt/c/Windows/ ]]; then
# Holy shit, I am on windows linux subsystem

unsetopt BG_NICE

function onproject() {
  TMUXMODE=$2 tmuxinator ${1}_env
}

else

function onproject() {
  TMUXMODE=$2 gnome-terminal --title="${1}" -x tmuxinator ${1}_env &
}

fi

function offproject() {
  tmux kill-session -t ${1} &
}

autoload -Uz onproject
autoload -Uz offproject

alias killproject='tmux kill-server'

fi

if [[ -f ~/dotfiles/ssh/ssh-ident ]]; then
  if type "python" > /dev/null; then
    # aliases
    alias git='BINARY_SSH=git ~/dotfiles/ssh/ssh-ident'
  fi
fi

if [[ -f /usr/bin/direnv ]]; then
# direnv
eval "$(direnv hook zsh)"
alias envrc_here='cp ~/dotfiles/direnv/derived.env ./.envrc'
fi

# Start built-in LAMP server in current directory
alias web='python -m SimpleHTTPServer 8000'
alias webcors='http-server -p 8000 --cors'

# remove locally all branches merged into develop
alias gitclean='git branch --merged develop | grep -v "\* develop" | xargs -n 1 git branch -d'


if [[ -f /usr/bin/docker ]]; then

alias docker_offload='export DOCKER_HOST="tcp://192.168.2.2:2375"'
alias docker_on='unset DOCKER_HOST && sudo service docker start'
# Reverse engineering for Dockerfile from image id, kind of  dfimage imageID
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm laniksj/dfimage"

export FORCE_IMAGE_REMOVAL=1
export MINIMUM_IMAGES_TO_SAVE=3

#docker helpers

function dck() {

local universalsh='sh -c  zsh; if [ "$?" -eq "127" ]; then bash; if [ "$?" -eq "127" ]; then  ash; if [ "$?" -eq "127" ]; then sh; fi; fi; fi'

case "$1" in
    list)
        sudo docker ps -a
        ;;
    manage)
        docker volume create portainer_data &&  docker run -d -p 9999:9000  -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
        ;;
    ui)
        docker start docker_ui || docker run -d -p 9999:9000 --name docker_ui --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker
        ;;
    p)
# -p 9000:9000 -p 8000:8000
        docker start portainer || docker run -d -p 9998:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
        ;;
    inspect)
        docker inspect $2 | jq $3
        ;;
    stopall)
        sudo docker stop $(sudo docker ps -a -q)
        ;;
    sh)
        sudo docker exec -it $(sudo docker ps -lq) ${2:-/bin/sh} $3 $4 $5 $6 $7 $8 $9
        ;;

    bash)
        sudo docker exec -it $(sudo docker ps -lq) ${2:-/bin/sh} $3 $4 $5 $6 $7 $8 $9
        ;;

    cleanimages)
        if [[ ! -f /usr/sbin/docker-gc ]]; then
        docker image prune --all --filter "until=400h"
        else
        sudo EXCLUDE_FROM_GC={$EXCLUDE_FROM_GC-/etc/docker-gc-exclude} MINIMUM_IMAGES_TO_SAVE=1 FORCE_IMAGE_REMOVAL=1 docker-gc
        fi
        ;;
    cleancontainers)
        if [[ ! -f /usr/bin/docker ]]; then
        docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm
        else
        sudo EXCLUDE_CONTAINERS_FROM_GC={$EXCLUDE_CONTAINERS_FROM_GC-/etc/docker-gc-exclude-containers} docker-gc
        fi

        ;;
    registry)
        docker start registry || docker run -d -p 5000:5000 --restart=always --name registry registry:2
        ;;
    *)
        echo "Usage: $0 {dck sh | bash | list |stopall |cleanimages |cleancontainers | ui | manage | registry | inspect <container name> <jq filter>}"
        echo "manage launches portrainer, ui - now obsolete ui for docker (retiring...)"
        echo "You are logged to following registries, if any"
        docker system info | grep -E 'Username|Registry'
        ;;
esac

}

autoload -Uz dck

fi


if type "gcloud" > /dev/null; then

source ${HOME}/dotfiles/completions/gcloud_completion.zsh


fi

if [[ -f ~/dotfiles/bin/vault ]]; then
  complete -o nospace -C /home/slavko/dotfiles/bin/vault vault
fi

export PATH=$PATH:${HOME}/dotfiles/bin

if type "kubectl" > /dev/null; then
  # load support for kubernetes context switch
  export PATH=$PATH:${HOME}/dotfiles/bin

  # heavy init
  function onkube() {
     kubeon
     source <(stern --completion=zsh)
#    source ${HOME}/dotfiles/bin/gcloud-ps1.sh
#    RPROMPT='$(gcloud_ps1)'
  }

fi


# ssh - add's github public ssh keys to authorized_keys of the current host
alias authorize_me='curl -L http://bit.ly/voronenko | bash -s'
alias mykey='xclip -selection c -i ~/.ssh/id_rsa.pub'

if [[ -f ~/dotfiles/gitflow/release_start.sh ]]; then

# gitflow
alias gitflow-init='git flow init -f -d'
alias gitflow-release-start='~/dotfiles/gitflow/release_start.sh'
alias gitflow-release-finish='~/dotfiles/gitflow/release_finish.sh'
alias gitflow-hotfix-start='~/dotfiles/gitflow/hotfix_start.sh'
alias gitflow-hotfix-finish='~/dotfiles/gitflow/hotfix_finish.sh'

fi

# sharing
alias sessionshare='screen -d -m -S shared'
alias sessionjoin='screen -x shared'
alias wanip='getent hosts `dig +short myip.opendns.com @resolver1.opendns.com`'
alias intranetip="ifconfig -a | grep inet | grep -v 127.0.0.1 | grep 192.168 | awk '{print \$2}'"

# source management
alias reset_rights_here='find -type f -exec chmod --changes 644 {} + -o -type d -exec chmod --changes 755 {} +'


# [ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

if [[ -f ~/.nvm/nvm.sh ]]; then

#source ~/.nvm/nvm.sh

declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("nvm", "nvm_find_nvmrc")

load_nvm () {
    export NVM_DIR=~/.nvm
    source ~/.nvm/nvm.sh
}

for cmd in "${NODE_GLOBALS[@]}"; do
    eval "${cmd}(){echo node lazy; unset -f ${NODE_GLOBALS} || true; load_nvm; ${cmd} \$@ }"
done


# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  if ! type "nvm" > /dev/null; then
    unset -f ${NODE_GLOBALS} || true;
    load_nvm
  fi
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

alias node_add_bin_path='export PATH="./node_modules/.bin/:$PATH"'

fi

# Python development

export PIPENV_VENV_IN_PROJECT=true

if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then

mkdir -p ~/.virtualenvs
export WORKON_HOME=$HOME/.virtualenvs

declare -a VRTENV_GLOBALS=(workon mkvirtualenv mkvirtualenv_venv mkvirtualenv_penv mkvirtualenv_venv3 mkvirtualenv_penv3)

load_vrtenv() {
source /usr/local/bin/virtualenvwrapper.sh

alias mkvirtualenv_venv='WORKON_HOME=$(pwd) mkvirtualenv --python python2.7 --no-site-packages venv && cp ~/dotfiles/venv/* $(pwd)/venv'
alias mkvirtualenv_penv='WORKON_HOME=$(pwd) mkvirtualenv --python python2.7 --no-site-packages p-env && cp ~/dotfiles/venv/* $(pwd)/p-env'

alias mkvirtualenv_venv3='WORKON_HOME=$(pwd) mkvirtualenv --python python3 --no-site-packages venv && cp ~/dotfiles/venv/* $(pwd)/venv'
alias mkvirtualenv_penv3='WORKON_HOME=$(pwd) mkvirtualenv --python python3 --no-site-packages p-env && cp ~/dotfiles/venv/* $(pwd)/p-env'
}

for cmd in "${VRTENV_GLOBALS[@]}"; do
    eval "${cmd}(){ unset -f ${VRTENV_GLOBALS}; load_vrtenv; ${cmd} \$@ }"
done

fi

if [[ -d ~/.virtualenvs/project_notes ]]; then

alias znotes='workon project_notes && cd ${ZNOTES_PATH-~/z_personal_notes} && jupyter lab'

fi

# >>> conda initialize >>>
# Get latest conda from https://docs.conda.io/en/latest/miniconda.html
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Java development

if [[ -d /opt/gradle ]]; then

export PATH=$PATH:/opt/gradle/gradle-3.3/bin

fi

if [[ -d ~/apps/hashi_vault_utils ]]; then

export PATH=$PATH:~/apps/hashi_vault_utils

fi

if [[ -d $HOME/.jenv ]]; then

  declare -a JENV_GLOBALS=(`find ~/.jenv/shims/ -maxdepth 1 -wholename '*' | xargs -n1 basename | sort | uniq`)
  JENV_GLOBALS+=("jenv")

  load_jenv () {
    eval "$(jenv init -)"
    export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
    alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'
  }

  for cmd in "${JENV_GLOBALS[@]}"; do
      eval "${cmd}(){echo jenv lazy; unset -f ${JENV_GLOBALS} || true; load_jenv; ${cmd} \$@ }"
  done

fi

# /Java development

# GO development
if [[ -d $HOME/.gimme/envs ]]; then

function gouse() {
  source ~/.gimme/envs/$1
}

fi
# /GO development


# Autoload ssh agent

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
#    echo "Initialising new SSH agent..."
    mkdir -p $HOME/.ssh
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add > /dev/null;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

if [[ -n $SSH_CONNECTION ]]; then
echo " .... remote session `echo $USER`@`hostname` .... "
fi

source ${HOME}/dotfiles/helpers/dotfiles_prompt.zsh

# if [[ -n $SSH_CONNECTION ]]; then
# echo " .... remote session `echo $USER`@`hostname` .... "
# #PROMPT="%{$fg_bold[yellow]%}⇕ ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)"
# PROMPT=$'%{$fg[yellow]%}┌%{$fg_bold[yellow]%}⇕%{$reset_color%}$fg[yellow]%}[%{$fg[cyan]%}%c%{$reset_color%}%{$fg[yellow]%}]> %{$(git_prompt_info)%}%(?,,%{$fg[yellow]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[yellow]%}])
# %{$fg[yellow]%}└──${ret_status}%{$reset_color%}'
# PS2=$' %{$fg[green]%}|>%{$reset_color%} '
#
# elif [[ -f /.dockerenv ]]; then
#
# PROMPT=$'%{$fg[yellow]%}┌%{$fg_bold[yellow]%}⭕ %{$reset_color%}$fg[yellow]%}[%{$fg[cyan]%}%c%{$reset_color%}%{$fg[yellow]%}]> %{$(git_prompt_info)%}%(?,,%{$fg[yellow]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[yellow]%}])
# %{$fg[yellow]%}└──${ret_status}%{$reset_color%}'
# PS2=$' %{$fg[green]%}|>%{$reset_color%} '
#
# else
# PROMPT=$'%{$fg[yellow]%}┌[%{$fg[cyan]%}%c%{$reset_color%}%{$fg[yellow]%}]> %{$(git_prompt_info)%}%(?,,%{$fg[yellow]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[yellow]%}])
# %{$fg[yellow]%}└──${ret_status}%{$reset_color%}'
# PS2=$' %{$fg[green]%}|>%{$reset_color%} '
#
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}[%{$fg_bold[white]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[yellow]%}] "
# ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}⚡%{$reset_color%}"
# fi

# Load cd helper
if [[ -f ~/dotfiles/helpers/z.sh ]]; then source ~/dotfiles/helpers/z.sh; fi

# AWS simplification
if [[ -d $HOME/.aws ]]; then


#
declare -a AWS_GLOBALS=(ec2ssh ec2forward ec2ssm)

load_ec2tools() {
source $HOME/dotfiles/helpers/ec2ssh.zsh
source $HOME/dotfiles/helpers/ec2forward.zsh
source $HOME/dotfiles/helpers/ec2ssm.zsh
}

for cmd in "${AWS_GLOBALS[@]}"; do
    eval "${cmd}(){ unset -f ${AWS_GLOBALS}; load_ec2tools; ${cmd} \$@ }"
done

# Load aws helper
if [[ -f /usr/local/bin/aws_zsh_completer.sh ]]; then source /usr/local/bin/aws_zsh_completer.sh; fi

  aws-profiles() {
    cat ~/.aws/credentials | grep '\[' | grep -v '#' | tr -d '[' | tr -d ']'
  }

  set-aws-profile() {
    local aws_profile=$1

    if [[ ! -z "$aws_profile" ]]; then
      region_data=$(cat ~/.aws/config | grep "\[profile $aws_profile\]" -A4 | grep -B 15 "^$")
      AWS_DEFAULT_REGION="$(echo $region_data | grep region | cut -f2 -d'=' | tr -d ' ')"
      set -x
      unset AWS_ACCESS_KEY_ID
      unset AWS_SECRET_ACCESS_KEY
      export AWS_PROFILE=${aws_profile}
      export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
      export AWS_DEFAULT_PROFILE=${aws_profile}
      set +x
      export TF_VAR_AWS_PROFILE=${AWS_PROFILE}
      export TF_VAR_AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
      export AWS_ORG_NAME=$(aws iam list-account-aliases --output text --query "AccountAliases[0]")
    else
      local declare selected_profile=($(aws-profiles | fzf))
      if [[ -n "$selected_profile" ]]; then
       if zle; then
            zle accept-line
        else
            print -z "set-aws-profile $selected_profile"
        fi
      fi
    fi
  }

  set-aws-keys() {
    local aws_profile=$1
    if [[ ! -z "$aws_profile" ]]; then
        profile_data=$(cat ~/.aws/credentials | grep "\[$aws_profile\]" -A4 | grep -B 15 "^$")
        AWS_ACCESS_KEY_ID="$(echo $profile_data | grep aws_access_key_id | cut -f2 -d'=' | tr -d ' ')"
        AWS_SECRET_ACCESS_KEY="$(echo $profile_data | grep aws_secret_access_key | cut -f2 -d'=' | tr -d ' ')"
        region_data=$(cat ~/.aws/config | grep "\[profile $aws_profile\]" -A4 | grep -B 15 "^$")
        AWS_DEFAULT_REGION="$(echo $region_data | grep region | cut -f2 -d'=' | tr -d ' ')"
        # output to screen, so you know
        # set -x
        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
        export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
        # set +x
        export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
        export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
        export TF_VAR_AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
        export AWS_ORG_NAME=$(aws iam list-account-aliases --output text --query "AccountAliases[0]")
        echo AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY were set for $1
    else
      local declare selected_profile=($(aws-profiles | fzf))
      if [[ -n "$selected_profile" ]]; then
       if zle; then
            zle accept-line
        else
            print -z "set-aws-keys $selected_profile"
        fi
      fi
    fi

  }

  set-aws-region() {
    local aws_region=$1
    if [[ ! -z "$aws_profile" ]]; then
      export AWS_DEFAULT_REGION=${aws_region}
      export AWS_REGION=${aws_region}
      export TF_AWS_DEFAULT_REGION=${aws_region}
      export TF_AWS_REGION=${aws_region}
    else
      local declare selected_region=($(aws ec2 describe-regions | jq -r '.Regions[].RegionName' | fzf))
      if [[ -n "$selected_region" ]]; then
       if zle; then
            zle accept-line
        else
            print -z "set-aws-region $selected_region"
        fi
      fi
    fi
  }

fi

# Windows syntethic sugar

alias 'startdot'='xdg-open .'
alias desktop_shortcut='gnome-desktop-item-edit ~/Desktop/ --create-new'

# Battery
alias batteries_fullcharge='sudo tlp fullcharge BAT0 && sudo tlp fullcharge BAT1'
alias battery_int_fullcharge='sudo tlp fullcharge BAT0'
alias battery_ext_fullcharge='sudo tlp fullcharge BAT1'
alias battery_ext_status='upower -i $(upower -e | grep BAT1)'
alias battery_int_status='upower -i $(upower -e | grep BAT0)'

# Time to sleep
alias 'nah'='echo "shutdown (ctrl-c to abort)?" && read && sudo shutdown 0'


if [[ -f /usr/bin/bat ]]; then
alias ccat='bat'
if type "fzf" > /dev/null; then

alias preview="fzf --preview 'bat --color \"always\" {}'"
alias fz="fzf --preview 'bat --color \"always\" {}'"

fi
fi

if type "fzf" > /dev/null; then
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort,f3:execute(less -f {}),f4:execute(nano {}),ctrl-l:execute-silent(echo {} | xclip -selection clipboard)+abort,f2:toggle-preview,enter:replace-query+print-query,ctrl-n:execute(bat {})'"
export FZF_DEFAULT_COMMAND='fd --hidden --exclude ".git" .';
# FZF_CTRL_T_OPTS
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
source ~/dotfiles/completions/fzf-completion.zsh
source ~/dotfiles/completions/fzf-key-binding.zsh
source ~/dotfiles/helpers/forgit.plugin.zsh
source ~/dotfiles/helpers/fzf-docker.zsh
source ~/dotfiles/helpers/jq.plugin.zsh

# fco - checkout git branch/tag
gco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
gco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# git commit with fixup
gcfixup() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  commit=$(git log --oneline origin/master.."$branch" | fzf | awk '{print $1}')

  git commit --fixup="$commit"
}

fi


if [[ -f ~/dotfiles/bin/prettyping ]]; then
alias pping='prettyping --nolegend'
fi

# cmd aliases

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias rsync_mirror='dsfdscfdsfdsf() { PARENTDIR=$(dirname `pwd`); [[ -n $1 ]] && rsync --progress -azh $PWD $1:$PARENTDIR };dsfdscfdsfdsf'
alias gpu_on='sudo prime-select nvidia'
alias gpu_off='sudo prime-select intel'
alias gpu='sudo prime-select query'
# turn displays off
alias doff='export DISPLAY=:0;sleep 3;xset dpms force off'
# eliminate snaps from df output
alias df='df -x"squashfs"'
# shows tag matched to checked-out commit or branch otherwise
alias gitinfo='git describe --exact-match --tags $(git log -n1 --pretty='%h') 2>/dev/null || echo "no tag, branch $(git branch --show-current)"'

# terminal shortcuts

if type "toggl" > /dev/null; then
  # bind ctrl-t to see currently tracked activity
  bindkey -s "^t" "^Q toggl now^J"
fi

# Anything locally specific?
if [[ -f ${HOME}/.zshrc.local ]]; then source ${HOME}/.zshrc.local; fi


if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof > ~/dotfiles/startup.log
    unsetopt xtrace
    exec 2>&3 3>&-
fi
