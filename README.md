dotfiles
========

My unix environment

So, to recap, the install script will:

* Back up any existing dotfiles in your home directory to ~/dotfiles_old/
* Create symlinks to the dotfiles in ~/dotfiles/ in your home directory
* Clone the oh-my-zsh repository from my GitHub (for use with zsh)
* Check to see if zsh is installed, if it isn't, try to install it.
* If zsh is installed, run a chsh -s to set it as the default shell.

TLDR;

Get basic zshrc + bashrc right now and optional bootstrap.sh for the future

```

curl -sSL https://bit.ly/getmyshell > getmyshell.sh && chmod +x getmyshell.sh && ./getmyshell.sh
```

OR https://bit.ly/slavkodotfiles for bootstrap.sh only

```
curl -sSL https://bit.ly/slavkodotfiles > bootstrap.sh && chmod +x bootstrap.sh
./bootstrap.sh  <optional: simple | full | docker>

```

# Some console perks (but not all)

#fzf

`COMMAND [DIRECTORY/][FUZZY_PATTERN]**<TAB>`  - lookup file/folder

`kill -9 <TAB>`  - lookup process

`ssh **<TAB>` - lookup host from ~/.ssh/confog

operate with envvars
```
unset **<TAB>
export **<TAB>
unalias **<TAB>
```

#/fzf

`z <tab>`  - quickly change to most often used dir with cd

`ga` Interactive git add selector

`glo` Interactive git log viewer

`gi` Interactive .gitignore generator

`gd` Interactive git diff viewer

`grh` Interactive git reset HEAD <file> selector

`gcf` Interactive git checkout <file> selector

`gss` Interactive git stash viewer

`gclean` Interactive git clean selector

`ec2ssh` - lookup and template ssh connection to machines you want to connect

`ec2ssm` - lookup instances to connect using aws ssm


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

Quick note on getting "merged" environments: placing `source_env` directive into `.envrc`
allows that effect. In other case, other environment variables will be uploaded.


```
source_env ..
```

If you also make use of hashicorp vault for secrets storage,
you can use following workaround with direnv:

```
PROJECT=SOMEPROJECT
export AWS_ACCESS_KEY_ID=$(vault read -field "value" secret/$PROJECT/aws/AWS_ACCESS_KEY_ID)
export AWS_SECRET_ACCESS_KEY=$(vault read -field "value" secret/$PROJECT/aws/AWS_SECRET_ACCESS_KEY)
export AWS_DEFAULT_REGION=us-east-1
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


# Windows WSL pervertions

If you want ssh service to be auto started on windows boot, you can create Windows Task Scheduler/Action -

```
Run when system startup

Run whether user is logged on or not. Save Password !!

%windir%\System32\bash.exe

-c "sudo service ssh start"
```


# Anything locally specific?

Add .zshrc.local - it gets parsed.

```sh
if [[ -f ${HOME}/.zshrc.local ]]; then source ${HOME}/.zshrc.local; fi
```

# Additional tools installable via make <action>

Kubernetes: ksonnet, stern

Multipurpose deployment generators:  kapitan

AWS EKS  heptio-authenticator-aws , eksctl

docker:  dry console tool

and few more:

`install-cdci-gitlab-runner`, `install-cdci-gitlab-runner-service` - helpers to debug gitlab pipelines locally

`install-cdci-circleci-runner` - helper to debug circleci pipeline locally

`install-console-bat` - `bat` is a `cat` on steroids with built in syntax colouring and git integration, https://github.com/sharkdp/bat

`install-console-prettytyping` - a bit visualization with ping, like `pping bbc.com`

`install-console-fzf` - A command-line fuzzy finder  https://github.com/junegunn/fzf , which extremely cool integrates into the shell ctrl-R, giving a nicier preview. I mostly use it in ctrl-R fashion, but interactive file finder is also used from time to time, followed by ctrl+O - open in vscode

In order to configure zsh integration - `zsh-fzh` action of the makefile.

`install-console-diffsofancy` - for me, better diff-er for git   https://github.com/so-fancy/diff-so-fancy

`install-console-fd` - quickier file finder (kind of fzf), syntax: fd PATTERN instead of find -iname '*PATTERN*'.  https://github.com/sharkdp/fd


`install-console-ripgrep` - ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern while respecting your gitignore rules  https://github.com/BurntSushi/ripgrep

`install-console-glances` -   Glances is a cross-platform monitoring tool which aims to present a large amount of monitoring information through a curses or Web based interface. The information dynamically adapts depending on the size of the user interface.  https://github.com/nicolargo/glances

`install-console-tldr` - community driven help on commands, usually provides more examples. Cool when you are not on your native linux distribution

`install-console-ncdu` - simply answers, where space goes, per directory.  https://dev.yorhel.nl/ncdu

```makefile

swiss-knife: install-console-prettytyping install-console-fzf install-console-diffsofancy install-docker-dry zsh-fzf install-hashicorp-terraform install-aws-key-importer
	@echo OK


# ZSH

# /ZSH


# CD CI local runners

install-cdci-gitlab-runner:
	sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
	sudo chmod +x /usr/local/bin/gitlab-runner

install-cdci-gitlab-runner-service:
	sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
	sudo chmod +x /usr/local/bin/gitlab-runner
	sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
	sudo gitlab-runner start

install-cdci-circleci-runner:
	curl https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh --fail --show-error | sudo bash

# /CD CI local runners


# CONSOLE TOOLS

install-console-bat:
	wget -O /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

install-console-prettytyping:
	wget -O ~/dotfiles/bin/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
	chmod +x ~/dotfiles/bin/prettyping

# https://github.com/junegunn/fzf
install-console-fzf:
	wget -O /tmp/fzf.tar.gz https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz
	tar -xvzf /tmp/fzf.tar.gz -C /tmp
	cp /tmp/fzf ~/dotfiles/bin
	echo "Consider running make zsh-fzf to install zsh shell integration"

# https://github.com/so-fancy/diff-so-fancy
install-console-diffsofancy:
	wget -O ~/dotfiles/bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x ~/dotfiles/bin/diff-so-fancy


install-console-fd:
	wget -O /tmp/fd.deb https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
	sudo dpkg -i /tmp/fd.deb

install-console-ripgrep:
	wget -O /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
	sudo dpkg -i /tmp/ripgrep.deb

install-console-glances:
	sudo pip install -U glances

# https://tldr.sh/
install-console-tldr:
	npm install -g tldr

install-console-ncdu:
	sudo apt-get install ncdu

# /CONSOLE TOOLS

# WORKSPACE TOOLS

install-workspace-github-release:
	mkdir -p /tmp/gh-release
	wget -O /tmp/gh-release/linux-amd64-github-release.tar.bz2 "https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2"
	cd /tmp/gh-release && tar jxf linux-amd64-github-release.tar.bz2 && mv /tmp/gh-release/bin/linux/amd64/github-release ~/dotfiles/bin
	rm -rf /tmp/gh-release

install-workspace-toggle-cli:
	sudo pip install togglCli

install-slack-term:
	wget -O ~/dotfiles/bin/slack-term https://github.com/erroneousboat/slack-term/releases/download/v0.4.1/slack-term-linux-amd64
	chmod +x ~/dotfiles/bin/slack-term

# /WORKSPACE TOOLS


# DOKER TOOLS


install-docker-machine:
	wget -O ~/dotfiles/bin/docker-machine https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-Linux-x86_64
	chmod +x ~/dotfiles/bin/docker-machine

install-docker-dry:
	wget -O ~/dotfiles/bin/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/bin/dry

# /DOKER TOOLS


# KUBERNETES

install-k8s-ksonnet:
	wget -O /tmp/ks_linux_amd64.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v0.10.1/ks_0.10.1_linux_amd64.tar.gz
	tar -xvzf /tmp/ks_linux_amd64.tar.gz -C /tmp
	cp /tmp/ks_0.10.1_linux_amd64/ks ~/dotfiles/bin

install-k8s-stern:
	wget -O ~/dotfiles/bin/stern "https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64"
	chmod +x ~/dotfiles/bin/stern

install-k8s-helm:
	mkdir -p /tmp/helm
	wget -O /tmp/helm/helm.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin
	rm -rf /tmp/helm

install-k8s-deepmind-kapitan:
	pip3 install --user --upgrade git+https://github.com/deepmind/kapitan.git  --process-dependency-links

install-k8s-heptio-authenticator-aws:
	curl -o ~/dotfiles/bin/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
	curl -o ~/dotfiles/bin/heptio-authenticator-aws.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws.md5
	chmod +x ~/dotfiles/bin/heptio-authenticator-aws

install-k8s-weaveworks-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl ~/dotfiles/bin

install-k8s-kubectl-ubuntu:
	sudo apt-get update && sudo apt-get install -y apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/kubernetes.list
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl

kube-dashboard-normal-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kube-dashboard-insecure-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
	echo possible to grant admin via  kubectl create -f ~/dotfiles/bin/k8s/dashboard-admin.yaml
	echo run kubectl proxy followed with http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default

# /KUBERNETES

workplace-init:
	./workplace_init.sh

workplace-init-mongo:
	./workplace_mongo_init.sh

workplace-sourcecodepro:
	./workplace_source_code_pro.sh

init:
	./init.sh

init_simple:
	./init_simple.sh


# GNOME specific extensions

gnome-dropdown-terminal:
	rm -rf /tmp/gnome-dropdown-terminal
	git clone https://github.com/zzrough/gs-extensions-drop-down-terminal /tmp/gnome-dropdown-terminal
	mv /tmp/gnome-dropdown-terminal/drop-down-terminal@gs-extensions.zzrough.org ~/.local/share/gnome-shell/extensions/drop-down-terminal@gs-extensions.zzrough.org

gnome-dash-to-dock:
	rm -rf /tmp/dash-to-dock
	git clone https://github.com/micheleg/dash-to-dock.git /tmp/dash-to-dock
	cd /tmp/dash-to-dock && make && make install

gnome-unite-shell:
	rm -rf /tmp/gnome-unite-shell
	git clone https://github.com/hardpixel/unite-shell.git /tmp/gnome-unite-shell
	mv /tmp/gnome-unite-shell/unite@hardpixel.eu ~/.local/share/gnome-shell/extensions/unite@hardpixel.eu

gnome-shell-system-monitor:
	sudo apt-get install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0  gir1.2-clutter-1.0
	rm -rf /tmp/gnome-shell-system-monitor-applet
	git clone https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet.git /tmp/gnome-shell-system-monitor-applet
	mv /tmp/gnome-shell-system-monitor-applet/system-monitor@paradoxxx.zero.gmail.com ~/.local/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com

gnome-shell-extension-timezone:
	git clone https://github.com/jwendell/gnome-shell-extension-timezone.git ~/.local/share/gnome-shell/extensions/timezone@jwendell
	gnome-shell-extension-tool -e timezone@jwendell

# /GNOME specific extensions

zsh-fzf:
	rm -rf ~/.oh-my-zsh/custom/plugins/fzf || true
	git clone https://github.com/junegunn/fzf.git ~/.oh-my-zsh/custom/plugins/fzf
	~/.oh-my-zsh/custom/plugins/fzf/install --bin
	mkdir -p ~/.oh-my-zsh/custom/plugins/fzf-zsh
	cp ~/dotfiles/helpers/fzf-zsh.plugin.zsh ~/.oh-my-zsh/custom/plugins/fzf-zsh


# TERRAFORM

install-terraform-ing:
	gem install terraforming

install-terraform-docs:
	wget -O ~/dotfiles/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v0.4.0/terraform-docs-v0.4.0-linux-amd64
	chmod +x ~/dotfiles/bin/terraform-docs

install-terraform-virtualbox-bridge:
	go get github.com/terra-farm/terraform-provider-virtualbox
	mkdir -p ~/.terraform.d/plugins
	cp $(GOPATH)/bin/terraform-provider-virtualbox ~/.terraform.d/plugins

# /TERRAFORM


# HASHICORP
install-hashicorp-vault:
	wget -O ~/dotfiles/bin/vault.zip "https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip vault.zip && chmod +x vault && rm vault.zip

install-hashicorp-terraform:
	wget -O ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

#/HASHICORP

# GO

install-go-gimme:
	curl -sL -o ~/dotfiles/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x ~/dotfiles/bin/gimme

go-rename:
	go get golang.org/x/tools/cmd/gorename

go-eg:
	go get golang.org/x/tools/cmd/eg

# /GO

# CLOUDS

install-aws-key-importer:
	wget -O ~/dotfiles/bin/aws-key-importer https://github.com/Voronenko/aws-key-importer/releases/download/0.2.0/aws-key-importer-linux-amd64
	chmod +x ~/dotfiles/bin/aws-key-importer

install-aws-myaws:
	wget -O /tmp/myaws.tar.gz https://github.com/minamijoyo/myaws/releases/download/v0.3.3/myaws_v0.3.3_linux_amd64.tar.gz
	tar -xvzf /tmp/myaws.tar.gz -C ~/dotfiles/bin

install-ovh-nova:
	sudo pip install python-openstackclient

# / CLOUDS


```


# Time to sleep

Done with work? Handy shortcut.

```sh
alias 'nah'='echo "shutdown (ctrl-c to abort)?" && read && sudo shutdown 0'
```


#  Fonts for prompt snippets


Adobe Source Code Pro: https://github.com/adobe-fonts/source-code-pro
Source Code Pro + Powerline: https://github.com/powerline/fonts/tree/master/SourceCodePro
Nerd Fonts Sauce Code Pro (might be derived from #2?): https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro/Regular
Awesome Fonts Sauce Code Powerline: https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/fonts
This random file that floats around. No idea where it came from, but it's referenced in many blog posts: https://github.com/bhilburn/dotfiles/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf


# Development box with vagrant

If your workplace is rather development box, like if you use vagrant often , 
consider modifiing sudoers exclusions, like `/etc/sudoers.d/YOURUSER` replacing slavko with your username

Note that by doing so you are doing your pc potentially less secure

```
#slavko ALL=(ALL) NOPASSWD: ALL

# vagrant-hostsupdater
Cmnd_Alias VAGRANT_HOSTS_ADD = /bin/sh -c echo "*" >> /etc/hosts
Cmnd_Alias VAGRANT_HOSTS_REMOVE = /usr/bin/sed -i -e /*/ d /etc/hosts
Cmnd_Alias VAGRANT_HOSTS_REMOVE2 = /bin/sed -i -e /*/ d /etc/hosts
slavko ALL=(root) NOPASSWD: VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE, VAGRANT_HOSTS_REMOVE2

# vagrant-nfs
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
slavko ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE, VAGRANT_TEMP_PREPARE

Cmnd_Alias VAGRANT_EXPORTS_CHOWN = /bin/chown 0\:0 /tmp/*
Cmnd_Alias VAGRANT_EXPORTS_MV = /bin/mv -f /tmp/* /etc/exports
Cmnd_Alias VAGRANT_NFSD_CHECK = /etc/init.d/nfs-kernel-server status
Cmnd_Alias VAGRANT_NFSD_START = /etc/init.d/nfs-kernel-server start
Cmnd_Alias VAGRANT_NFSD_APPLY = /usr/sbin/exportfs -ar
slavko ALL=(root) NOPASSWD: VAGRANT_EXPORTS_CHOWN, VAGRANT_EXPORTS_MV, VAGRANT_NFSD_CHECK, VAGRANT_NFSD_START, VAGRANT_NFSD_APPLY

# /vagrant-nfs

slavko ALL=(ALL) NOPASSWD: /usr/bin/truecrypt
slavko ALL=(ALL) NOPASSWD: /bin/systemctl
slavko ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown
slavko ALL=(ALL) NOPASSWD: /etc/init.d/nginx, /etc/init.d/mysql, /etc/init.d/mongod, /etc/init.d/redis, /etc/init.d/php-fpm, /usr/bin/pritunl-client-pk-start
slavko ALL=(ALL) NOPASSWD:SETENV: /usr/bin/docker, /usr/sbin/docker-gc, /usr/bin/vagrant


```

DO NOT PROCEED with similar setup on internet facing production servers
