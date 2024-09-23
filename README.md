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

as a part of helper for docker https://github.com/MartinRamm/fzf-docker.git

| command | description                                               | fzf mode | command arguments (optional)                                                                                 |
| ------- | --------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------ |
| dr      | docker restart && open logs (in follow mode)              | multiple |                                                                                                              |
| dl      | docker logs (in follow mode)                              | multiple | time interval - e.g.: `1m` for 1 minute - (defaults to all available logs)                                   |
| dla     | docker logs (in follow mode) all containers               |          | time interval - e.g.: `1m` for 1 minute - (defaults to all available logs)                                   |
| de      | docker exec in interactive mode                           | single   | command to exec (default - see below)                                                                        |
| drm     | docker remove container (with force)                      | multiple |                                                                                                              |
| drma    | docker remove all containers (with force)                 |          |                                                                                                              |
| ds      | docker stop                                               | multiple |                                                                                                              |
| dsa     | docker stop all running containers                        |          |                                                                                                              |
| dsrm    | docker stop and remove container                          | multiple |                                                                                                              |
| dsrma   | docker stop and remove all container                      |          |

| dk      | docker kill                                               | multiple |                                                                                                              |
| dka     | docker kill all containers                                |          |                                                                                                              |
| dkrm    | docker kill and remove container                          | multiple |                                                                                                              |
| dkrma   | docker kill and remove all container                      |          |                                                                                                              |
| drmi    | docker remove image (with force)                          | multiple |                                                                                                              |
| drmia   | docker remove all images (with force)                     |          |                                                                                                              |
| dclean  | `dsrma` and `drmia`                                       |          |                                                                                                              |


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
if [[ -f /usr/bin/tmux || -f /usr/local/bin/tmux ]]; then

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

# Jupyter notebook git diff integration?

https://nbdime.readthedocs.io/en/latest/vcs.html

```sh
nbdime config-git (--enable | --disable) [--global | --system]
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

If for some reason you do not know sudo password for your wsl user (sic!), use

```
wsl --user root
```

to get root session for wsl, and than

```
passwd user
```

where `user` is your wsl user


## Connect Nitrokey / Yubikey device inside WSL

Use brilliant https://github.com/dorssel/usbipd-win/releases

1. List all of the USB devices connected to Windows by opening PowerShell in _administrator_ mode and entering the following command.
Once the devices are listed, select and copy the bus ID of the device you’d like to attach to WSL.

```shell
usbipd list
```

2. Before attaching the USB device, the command `usbipd bind` must be used to share the device, allowing it to be attached to WSL.
This requires administrator privileges. Select the bus ID of the device you would like to use in WSL and run the following command.
 After running the command, verify that the device is shared using the command `usbipd list` again.

```shell
usbipd bind --busid 4-4
```

3. To attach the USB device, run the following command. (You no longer need to use an elevated administrator prompt.) Ensure that a WSL command prompt is open in order to keep the WSL 2 lightweight VM active.

Note that as long as the USB device is attached to WSL, it cannot be used by Windows. Once attached to WSL, the USB device can be used by any distribution running as WSL 2.
Verify that the device is attached using `usbipd list`. From the WSL prompt, run `lsusb` to verify that the USB device is listed and can be interacted with using Linux tools.

```
usbipd attach --wsl --busid <busid>
```

4. Open Ubuntu (or your preferred WSL command line) and list the attached USB devices using the command:


```
lsusb
```

You should see the device you just attached and be able to interact with it using normal Linux tools. Depending on your application, you may need to configure udev rules to allow non-root users to access the device.

5. Once you are done using the device in WSL, you can either physically disconnect the USB device or run this command from PowerShell:

```shell
usbipd detach --busid <busid>
```

## Upgrade nitrokey version, dirty

```sh
nitropy nk3 reboot --bootloader
nitropy nk3 list
# output should include Nitrokey 3 Bootloader followed by the UUID
nitropy nk3 update
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
swiss-knife: swiss-fzf swiss-console swiss-ops swiss-zsh fonts-swiss-knife
	@echo OK

swiss-fzf: zsh-fzf-repo install-console-fzf zsh-fzf
	@echo FZF OK

swiss-docker: install-docker-dry install-docker-machine
	@echo docker ok

swiss-console: install-console-bat install-console-prettytyping install-console-diffsofancy install-console-fd install-console-ripgrep install-console-ncdu install-console-yq install-ngrok install-direnv
	@echo console ok

swiss-console-python: install-console-glances
	@echo python based console tools ok

swiss-ops: install-hashicorp-terraform install-terraform-docs install-hashicorp-vault install-hashicorp-packer
	@echo ops tools ok
	@echo if you need reverse engineering consider make install-terraformer

swiss-k8s: install-k8s-ksonnet install-k8s-stern install-k8s-helm3-fixed install-k8s-deepmind-kapitan install-k8s-kubectl-ubuntu install-k8s-kubefwd install-k8s-kubeval install-k8s-kubeval install-k8s-rakkess install-k8s-popeye install-k8s-polaris install-k8s-kubespy install-k8s-vmware-octant
	@echo k8s tools ok

swiss-zsh: zsh-alias-tips fonts-awesome-terminal-fonts fonts-source-code-pro fonts-source-code-pro-patched
	@echo zsh extras ok

swiss-aws:  install-aws-key-importer install-aws-myaws
	@echo aws tools added



# ZSH
zsh-fzf-repo:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# /ZSH


# CD CI local runners

install-cdci-gitlab-runner:
	sudo curl -sLo /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
	sudo chmod +x /usr/local/bin/gitlab-runner

install-cdci-gitlab-runner-service:
	sudo curl -sLo /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
	sudo chmod +x /usr/local/bin/gitlab-runner
	sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
	sudo gitlab-runner start

install-cdci-circleci-runner:
#	curl -sLo /tmp/circleci.tar.gz https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.10993/circleci-cli_0.1.10993_linux_amd64.tar.gz
	curl -sLo /tmp/circleci.tar.gz https://github.com/CircleCI-Public/circleci-cli/releases/download/v$(shell curl -s https://api.github.com/repos/CircleCI-Public/circleci-cli/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c 2-)/circleci-cli_$(shell curl -s https://api.github.com/repos/CircleCI-Public/circleci-cli/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c 2-)_linux_amd64.tar.gz
	tar -xvzf /tmp/circleci.tar.gz -C /tmp
	rm -rf /tmp/circleci-cli || true
	cd /tmp && mv circleci-cli_* circleci-cli
	mv /tmp/circleci-cli/circleci ~/dotfiles/bin/circleci
	chmod +x ~/dotfiles/bin/circleci


# /CD CI local runners


# CONSOLE TOOLS

install-tmuxinator:
	gem install tmuxinator

# jsonnet processing tool
install-console-jsonnet: install-console-yq
	curl -sLo /tmp/jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v0.14.0/jsonnet-bin-v0.14.0-linux.tar.gz
	tar -xvzf /tmp/jsonnet.tar.gz -C /tmp
	cp /tmp/jsonnet ~/dotfiles/bin
	cp /tmp/jsonnetfmt ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/jsonnet ~/dotfiles/bin/jsonnetfmt

install-mysql-skeema:
	curl -sLo /tmp/skeema.tar.gz https://github.com/skeema/skeema/releases/download/v1.4.2/skeema_1.4.2_linux_amd64.tar.gz
	tar -xvzf /tmp/skeema.tar.gz -C /tmp
	cp /tmp/skeema ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/skeema

install-mysql-dbmate:
	curl -sLo ~/dotfiles/bin/dbmate https://github.com/amacneil/dbmate/releases/download/v1.7.0/dbmate-linux-amd64
	chmod +x ~/dotfiles/bin/dbmate

# cat with syntax highlight https://github.com/sharkdp/bat
install-console-bat:
	curl -sLo /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

# https://github.com/jesseduffield/lazygit
install-console-lazygit:
	curl -sLo /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.20.4/lazygit_0.20.4_Linux_x86_64.tar.gz
	tar -xvzf /tmp/lazygit.tar.gz -C /tmp
	mv /tmp/lazygit ~/dotfiles/bin

# http://lnav.org/
install-console-logreader-lnav:
	curl -sLo /tmp/lnav.zip https://github.com/tstack/lnav/releases/download/v0.8.5/lnav-0.8.5-linux-64bit.zip
	cd /tmp && unzip lnav.zip
	mv /tmp/lnav-0.8.5/lnav ~/dotfiles/bin
	lnav -i extra

# https://github.com/rcoh/angle-grinder#query-syntax
install-console-logreader-agrind:
	curl -sLo /tmp/agrind.tar.gz https://github.com/rcoh/angle-grinder/releases/download/v0.13.0/angle_grinder-v0.13.0-x86_64-unknown-linux-musl.tar.gz
	tar -xvzf /tmp/agrind.tar.gz -C /tmp
	cp /tmp/agrind ~/dotfiles/bin/ag
	chmod +x ~/dotfiles/bin/ag

# https://github.com/denilsonsa/prettyping
# prettyping 8.8.8.8
install-console-prettytyping:
	curl -sLo ~/dotfiles/bin/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
	chmod +x ~/dotfiles/bin/prettyping

# https://github.com/junegunn/fzf
install-console-fzf:
	curl -sLo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/0.24.3/fzf-0.24.3-linux_amd64.tar.gz
	tar -xvzf /tmp/fzf.tar.gz -C /tmp
	cp /tmp/fzf ~/dotfiles/bin
	echo "Consider running make zsh-fzf to install zsh shell integration"

# WTF is a personal information dashboard for your terminal, developed for those who spend most of their day in the command line.
install-console-wtfutil:
	curl -sLo /tmp/wtf.tar.gz https://github.com/wtfutil/wtf/releases/download/v0.30.0/wtf_0.30.0_linux_amd64.tar.gz
	tar -xvzf /tmp/wtf.tar.gz -C /tmp
	cp /tmp/wtf_0.30.0_linux_amd64/wtfutil ~/dotfiles/bin/wtfutil
	chmod +x ~/dotfiles/bin/wtfutil

# https://github.com/so-fancy/diff-so-fancy
install-console-diffsofancy:
	curl -sLo ~/dotfiles/bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x ~/dotfiles/bin/diff-so-fancy

# fd is a simple, fast and user-friendly alternative to find. https://github.com/sharkdp/fd
# fd service
install-console-fd:
#	curl -sLo /tmp/fd.deb https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
#	sudo dpkg -i /tmp/fd.deb
	curl -sLo /tmp/fd.tar.gz https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-v8.1.1-x86_64-unknown-linux-gnu.tar.gz
	tar -xvzf /tmp/fd.tar.gz -C /tmp
	cp /tmp/fd-v8.1.1-x86_64-unknown-linux-gnu/fd* ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/fd

# ripgrep recursively searches directories for a regex pattern https://github.com/BurntSushi/ripgrep
# rg -n -w '[A-Z]+_SUSPEND'
install-console-ripgrep:
	curl -sLo /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
	sudo dpkg -i /tmp/ripgrep.deb

# Glances is a cross-platform monitoring tool which aims
# to present a large amount of monitoring information
install-console-glances:
	sudo pip install -U glances

# https://tldr.sh/
install-console-tldr:
	npm install -g tldr

# disk usage analyzer with an ncurses interface
install-console-ncdu:
	sudo apt-get install ncdu

# jql for yml
install-console-yq:
	curl -sLo ~/dotfiles/bin/yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
	chmod +x ~/dotfiles/bin/yq

install-ngrok:
	curl -sLo ~/dotfiles/bin/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	cd ~/dotfiles/bin/ && unzip ngrok.zip
	rm ~/dotfiles/bin/ngrok.zip

# /CONSOLE TOOLS

# WORKSPACE TOOLS

install-workspace-github-release:
	mkdir -p /tmp/gh-release
	curl -sLo /tmp/gh-release/linux-amd64-github-release.tar.bz2 "https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2"
	cd /tmp/gh-release && tar jxf linux-amd64-github-release.tar.bz2 && mv /tmp/gh-release/bin/linux/amd64/github-release ~/dotfiles/bin
	rm -rf /tmp/gh-release

install-workspace-toggle-cli:
	sudo pip install togglCli

install-slack-term:
	curl -sLo ~/dotfiles/bin/slack-term https://github.com/erroneousboat/slack-term/releases/download/v0.4.1/slack-term-linux-amd64
	chmod +x ~/dotfiles/bin/slack-term

install-direnv:
	curl -sLo ~/dotfiles/bin/direnv https://github.com/direnv/direnv/releases/download/v2.19.1/direnv.linux-amd64
	chmod +x ~/dotfiles/bin/direnv

# https://github.com/VirtusLab/git-machete
# https://plugins.jetbrains.com/plugin/14221-git-machete
install-git-machete:
	curl -L https://raw.githubusercontent.com/VirtusLab/git-machete/master/completion/git-machete.completion.zsh -o ~/dotfiles/completions/git-machete.completion.zsh
	sudo snap install --classic git-machete

# https://pre-commit.com/
install-git-precommit:
	pip3 install pre-commit
	#conda install -c conda-forge pre-commit
	git config --global init.templateDir ~/.git-template
	pre-commit init-templatedir ~/.git-template

# /WORKSPACE TOOLS


# DOCKER TOOLS


install-docker-machine:
	curl -sLo ~/dotfiles/bin/docker-machine https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-Linux-x86_64
	chmod +x ~/dotfiles/bin/docker-machine

# docker console manager
install-docker-dry:
	curl -sLo ~/dotfiles/bin/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/bin/dry

# inspection of the docker containers
install-docker-dive:
	curl -sLo /tmp/dive.deb https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
	sudo apt install /tmp/dive.deb

# https://dockersl.im
install-docker-slim:
	curl -sLo /tmp/docker-slim.tar.gz https://downloads.dockerslim.com/releases/1.29.0/dist_linux.tar.gz
	tar -xvzf /tmp/docker-slim.tar.gz -C /tmp
	mv /tmp/dist_linux/* ~/dotfiles/bin

# templating utility for easy config patching using bash variables syntax
install-docker-envplate:
	curl -sLo ~/dotfiles/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux && chmod +x ~/dotfiles/bin/ep

# /DOCKER TOOLS


# KUBERNETES
# includes upgrade, disables k3s by default as you don't need it up on dev notebook
install-k3s-local:
	curl -sfL https://get.k3s.io | sh -
	sudo systemctl disable k3s
# https://github.com/alexellis/k3sup/
install-k3s-up:
	curl -sLo ~/dotfiles/bin/k3sup https://github.com/alexellis/k3sup/releases/download/0.9.2/k3sup
	chmod +x ~/dotfiles/bin/k3sup

install-k8s-ksonnet:
	curl -sLo /tmp/ks_linux_amd64.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v0.10.1/ks_0.10.1_linux_amd64.tar.gz
	tar -xvzf /tmp/ks_linux_amd64.tar.gz -C /tmp
	cp /tmp/ks_0.10.1_linux_amd64/ks ~/dotfiles/bin

# tail utility for kubernetes
install-k8s-stern:
	curl -sLo ~/dotfiles/bin/stern "https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64"
	chmod +x ~/dotfiles/bin/stern

# helm version considered stable
install-k8s-helm3-fixed:
	mkdir -p /tmp/helm
	curl -sLo /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-v3.1.0-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
	rm -rf /tmp/helm

# latest released helm
install-k8s-helm-latest:
	mkdir -p /tmp/helm
	curl -sLo /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-$(shell curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
	rm -rf /tmp/helm

install-k8s-deepmind-kapitan:
	pip3 install --user --upgrade git+https://github.com/deepmind/kapitan.git  --process-dependency-links

install-k8s-heptio-authenticator-aws:
	curl -o ~/dotfiles/bin/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
	curl -o ~/dotfiles/bin/heptio-authenticator-aws.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws.md5
	chmod +x ~/dotfiles/bin/heptio-authenticator-aws

install-k8s-aws-iam-authenticator:
	curl -o ~/dotfiles/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.8/2020-09-18/bin/linux/amd64/aws-iam-authenticator
	chmod +x ~/dotfiles/bin/aws-iam-authenticator

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
# terminal UI to interact with your Kubernetes
install-k8s-k9s:
	mkdir -p /tmp/k9s
	curl -sLo /tmp/k9s/k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.22.1/k9s_Linux_x86_64.tar.gz
	cd /tmp/k9s && tar -xzf k9s.tar.gz && mv /tmp/k9s/k9s ~/dotfiles/bin/
	chmod +x ~/dotfiles/bin/k9s
	rm -rf /tmp/k9s

# kubie is an alternative to kubectx, kubens and the k on prompt modification script. It offers context switching, namespace switching and prompt modification
# in a way that makes each shell independent from others. It also has support for split configuration files, meaning it can load Kubernetes contexts from
# multiple files. You can configure the paths where kubie will look for context
install-k8s-kubie:
	curl -J -L -o ~/dotfiles/bin/kubie https://github.com/sbstp/kubie/releases/download/v0.9.1/kubie-linux-amd64
	chmod +x ~/dotfiles/bin/kubie

# https://github.com/txn2/kubefwd/
# Bulk port forwarding Kubernetes services for local development.
# https://imti.co/kubernetes-port-forwarding/
install-k8s-kubefwd:
	curl -sLo /tmp/kubefwd.deb https://github.com/txn2/kubefwd/releases/download/1.12.0/kubefwd_amd64.deb
	sudo apt install /tmp/kubefwd.deb

# https://github.com/instrumenta/kubeval/
install-k8s-kubeval:
	curl -sLo /tmp/kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/0.14.0/kubeval-linux-amd64.tar.gz
	tar -xvzf /tmp/kubeval.tar.gz -C /tmp
	cp /tmp/kubeval ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/kubeval

# https://github.com/vmware-tanzu/octant/
# Kubernetes dashboard by VMWare
install-k8s-vmware-octant:
	curl -sLo /tmp/octant.deb https://github.com/vmware-tanzu/octant/releases/download/v0.10.2/octant_0.10.2_Linux-64bit.deb
	sudo apt install /tmp/octant.deb
	echo use octant --listener-addr 0.0.0.0:7777 to listen remotely

# https://github.com/corneliusweig/rakkess
# Review Access - kubectl plugin to show an access matrix for k8s server resources
install-k8s-rakkess:
	curl -Lo /tmp/rakkess.tar.gz https://github.com/corneliusweig/rakkess/releases/download/v0.4.5/rakkess-amd64-linux.tar.gz && \
	tar -xvzf /tmp/rakkess.tar.gz -C /tmp
	cd /tmp && mv rakkess-amd64-linux ~/dotfiles/bin/rakkess
	chmod +x ~/dotfiles/bin/rakkess

# https://github.com/derailed/popeye
# A Kubernetes cluster resource sanitizer
install-k8s-popeye:
	curl -sLo /tmp/popeye.tar.gz https://github.com/derailed/popeye/releases/download/$(shell curl -s https://api.github.com/repos/derailed/popeye/releases/latest | grep tag_name | cut -d '"' -f 4)/popeye_Linux_x86_64.tar.gz
	tar -xvzf /tmp/popeye.tar.gz -C /tmp
	cp /tmp/popeye ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/popeye

#  https://github.com/FairwindsOps/polaris
#  Validation of best practices in your Kubernetes clusters https://www.fairwinds.com/polaris
install-k8s-polaris:
	curl -sLo /tmp/polaris.tar.gz https://github.com/FairwindsOps/polaris/releases/download/0.6.0/polaris_0.6.0_Linux_x86_64.tar.gz
	tar -xvzf /tmp/polaris.tar.gz -C /tmp
	cp /tmp/polaris ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/polaris
	echo with KUBECONFIG set, polaris --dashboard --dashboard-port 8080
	echo you can also install inside cluster:
	echo kubectl apply -f https://github.com/fairwindsops/polaris/releases/latest/download/dashboard.yaml
	echo kubectl port-forward --namespace polaris svc/polaris-dashboard 8080:80

# https://github.com/pulumi/kubespy
# Tools for observing Kubernetes resources in real time, powered by Pulumi
install-k8s-kubespy:
#	curl -sLo /tmp/kubespy.tar.gz https://github.com/pulumi/kubespy/releases/download/v0.5.0/kubespy-linux-amd64.tar.gz
	curl -sLo /tmp/kubespy.tar.gz https://github.com/pulumi/kubespy/releases/download/$(shell curl -s https://api.github.com/repos/pulumi/kubespy/releases/latest | grep tag_name | cut -d '"' -f 4)/kubespy-$(shell curl -s https://api.github.com/repos/pulumi/kubespy/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64.tar.gz
	tar -xvzf /tmp/kubespy.tar.gz -C /tmp
	rm ~/dotfiles/bin/kubectl-spy || true
	cp /tmp/kubespy ~/dotfiles/bin
	ln -s ~/dotfiles/bin/kubespy  ~/dotfiles/bin/kubectl-spy

# https://skaffold.dev/
install-k8s-skaffold:
	curl -Lo ~/dotfiles/bin/skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
	chmod +x ~/dotfiles/bin/skaffold

install-k8s-kubebox:
	curl -Lo ~/dotfiles/bin/kubebox https://github.com/astefanutti/kubebox/releases/download/v0.8.0/kubebox-linux
	chmod +x ~/dotfiles/bin/kubebox
	echo Do not forget to install cadvisor, for example kubectl apply -f https://raw.github.com/astefanutti/kubebox/master/cadvisor.yaml

# https://github.com/ksync/ksync/
# It transparently updates containers running on the cluster from your local checkout.
# docker run -v /foo:/bar =>  ksync create --pod=my-pod local_directory remote_directory
# ksync watch
install-k8s-ksync:
	curl -Lo ~/dotfiles/bin/ksync https://github.com/ksync/ksync/releases/download/0.4.5/ksync_linux_amd64
	chmod +x ~/dotfiles/bin/ksync

kube-dashboard-normal-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kube-dashboard-insecure-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
	echo possible to grant admin via  kubectl create -f ~/dotfiles/bin/k8s/dashboard-admin.yaml
	echo run kubectl proxy followed with http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default

install-openshift-oc:
	curl -sLo /tmp/openshift.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
	tar -xvzf /tmp/openshift.tar.gz -C /tmp
	mv /tmp/openshift-origin-client-tools-*  /tmp/openshift-origin-client-tools
	cp /tmp/openshift-origin-client-tools/oc ~/dotfiles/bin
	type kubectl >/dev/null || /tmp/openshift-origin-client-tools/oc ~/dotfiles/bin
	echo "If there were no kubectl in path, one was installed from oc distro."
	echo "In other case global is used. Please check carefully"

install-helm-common-repos:
	helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator || true
	helm repo add gitlab https://charts.gitlab.io || true
	helm repo add eks https://aws.github.io/eks-charts
	helm repo add bitnami https://charts.bitnami.com/bitnami

zsh-kubetail:
	rm -rf ~/.oh-my-zsh/custom/plugins/kubetail || true
	git clone https://github.com/johanhaleby/kubetail.git ~/.oh-my-zsh/custom/plugins/kubetail

# /KUBERNETES

# IGNITE
install-weaveworks-ignite:
	curl -fLo ~/dotfiles/bin/ignite https://github.com/weaveworks/ignite/releases/download/v0.4.1/ignite
	chmod +x ~/dotfiles/bin/ignite
	# eliminate when ignite adds support for sudoer
	sudo cp /home/slavko/dotfiles/bin/ignite /usr/local/bin
remove-weaveworks-ignite:
	# Force-remove all running VMs
	sudo ignite ps -q | xargs sudo ignite rm -f
	# Remove the data directory
	sudo rm -r /var/lib/firecracker
	# Remove the Ignite binary
	rm ~/dotfiles/bin/ignite
# /IGNITE

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

# Check issue  https://github.com/jwendell/gnome-shell-extension-timezone/issues/41
gnome-shell-extension-timezone:
	git clone https://github.com/jwendell/gnome-shell-extension-timezone.git ~/.local/share/gnome-shell/extensions/timezone@jwendell
	gnome-shell-extension-tool -e timezone@jwendell

gnome-shell-window-corner-preview:
	rm -rf /tmp/window-corner-preview
	git clone https://github.com/medenagan/window-corner-preview.git /tmp/window-corner-preview
	mv /tmp/window-corner-preview/window-corner-preview@fabiomereu.it ~/.local/share/gnome-shell/extensions/window-corner-preview@fabiomereu.it

gnome-shell-gnome-extension-quicktoggler:
	rm -rf /tmp/gnome-extension-quicktoggler
	git clone https://github.com/Shihira/gnome-extension-quicktoggler.git /tmp/gnome-extension-quicktoggler
	mv /tmp/gnome-extension-quicktoggler ~/.local/share/gnome-shell/extensions/quicktoggler@shihira.github.com
# /GNOME specific extensions

zsh-fzf:
	rm -rf ~/.oh-my-zsh/custom/plugins/fzf || true
	git clone https://github.com/junegunn/fzf.git ~/.oh-my-zsh/custom/plugins/fzf
	~/.oh-my-zsh/custom/plugins/fzf/install --bin
	mkdir -p ~/.oh-my-zsh/custom/plugins/fzf-zsh
	cp ~/dotfiles/helpers/fzf-zsh.plugin.zsh ~/.oh-my-zsh/custom/plugins/fzf-zsh

# +plugins=(... alias-tips)
zsh-alias-tips:
	git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips


# TERRAFORM

install-terraform-ing:
	gem install terraforming

install-terraform-terraspace:
	gem install terraspace

#https://github.com/GoogleCloudPlatform/terraformer
install-terraformer:
	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(shell curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-all-linux-amd64
	chmod +x terraformer-all-linux-amd64
	mv terraformer-all-linux-amd64 ~/dotfiles/bin/terraformer
	chmod +x ~/dotfiles/bin/terraformer

	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(shell curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-google-linux-amd64
	chmod +x terraformer-google-linux-amd64
	mv terraformer-google-linux-amd64 ~/dotfiles/bin/terraformer_google
	chmod +x ~/dotfiles/bin/terraformer_google

	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(shell curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-aws-linux-amd64
	chmod +x terraformer-aws-linux-amd64
	mv terraformer-aws-linux-amd64 ~/dotfiles/bin/terraformer_aws
	chmod +x ~/dotfiles/bin/terraformer_aws

	curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(shell curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-kubernetes-linux-amd64
	chmod +x terraformer-kubernetes-linux-amd64
	mv terraformer-kubernetes-linux-amd64 ~/dotfiles/bin/terraformer_kubernetes
	chmod +x ~/dotfiles/bin/terraformer_kubernetes

install-terraform-docs:
	curl -sLo ~/dotfiles/bin/terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)/terraform-docs-$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64
	chmod +x ~/dotfiles/bin/terraform-docs

install-terraform-virtualbox-bridge:
	go get github.com/terra-farm/terraform-provider-virtualbox
	mkdir -p ~/.terraform.d/plugins
	cp $(GOPATH)/bin/terraform-provider-virtualbox ~/.terraform.d/plugins

install-terraform-tfschema:
	curl -sLo /tmp/tfschema.tar.gz https://github.com/minamijoyo/tfschema/releases/download/v0.3.0/tfschema_0.3.0_linux_amd64.tar.gz
	tar -xvzf /tmp/tfschema.tar.gz -C /tmp
	cp /tmp/tfschema ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/tfschema

# interactive d3js-graphviz visualization for terraform graph (beta)
install-terraform-blast:
	pip install blastradius

install-tflint:
	curl -sLo /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/$(shell curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep tag_name | cut -d '"' -f 4)/tflint_linux_amd64.zip
	cd /tmp && unzip tflint.zip
	mv /tmp/tflint ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/tflint
# /TERRAFORM


# HASHICORP
install-hashicorp-vault:
	curl -sLo ~/dotfiles/bin/vault.zip "https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip vault.zip && chmod +x vault && rm vault.zip

install-hashicorp-terraform011:
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform011 && chmod +x terraform011 && rm terraform.zip && mv terraform011 ~/dotfiles/bin/


install-hashicorp-terraform012:
	curl -sLo ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-hashicorp-terraform:
	curl -sLo ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-hashicorp-packer:
	curl -sLo ~/dotfiles/bin/packer.zip "https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip packer.zip && chmod +x packer && rm packer.zip


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

# JAVA

install-jenv:
	git clone https://github.com/gcuisinier/jenv.git ~/.jenv
	echo "================================================="
	echo "Restart session, than once you have jenv"
	echo "jenv enable-plugins maven"
	echo "jenv enable-plugins export"
	echo "======== then discover java versions:"
	echo "update-alternatives --config java"
	echo "======== Add java versions as"
	echo "/usr/lib/jvm/java-11-openjdk-amd64/"
	echo "Validate install and checking both java -version and javac -version"
	echo "That should match"
	echo "run 'jenv doctor' in case of issues"

# /JAVA

# CLOUDS

install-aws-key-importer:
	curl -sLo ~/dotfiles/bin/aws-key-importer https://github.com/Voronenko/aws-key-importer/releases/download/0.2.0/aws-key-importer-linux-amd64
	chmod +x ~/dotfiles/bin/aws-key-importer

install-aws-myaws:
	curl -sLo /tmp/myaws.tar.gz https://github.com/minamijoyo/myaws/releases/download/v0.3.10/myaws_v0.3.10_linux_amd64.tar.gz
	tar -xvzf /tmp/myaws.tar.gz -C ~/dotfiles/bin

# https://github.com/peak/s5cmd/
install-aws-s5cmd:
	curl -sLo /tmp/s5cmd.tar.gz https://github.com/peak/s5cmd/releases/download/v1.1.0/s5cmd_1.1.0_Linux-64bit.tar.gz
	tar -xvzf /tmp/s5cmd.tar.gz -C /tmp
	cp /tmp/s5cmd ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/s5cmd

install-aws-awless:
	curl -sLo /tmp/awless.tar.gz https://github.com/wallix/awless/releases/download/v0.1.11/awless-linux-amd64.tar.gz
	tar -xvzf /tmp/awless.tar.gz -C ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/awless

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
install-aws-cli2:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
	cd /tmp && unzip awscliv2.zip
	cd /tmp && sudo ./aws/install

install-ovh-nova:
	sudo pip install python-openstackclient

# https://console.aws.amazon.com/cloudformation/designer
# https://github.com/awslabs/aws-cfn-template-flip
install-aws-cfn-template-flip:
	sudo pip3 install cfn-flip

# / CLOUDS

# ESXI
# https://github.com/softasap/esxi-vm
install-esxi-tools:
	curl -sLo ~/dotfiles/bin/esxi-vm-create https://raw.githubusercontent.com/softasap/esxi-vm/master/esxi-vm-create
	chmod +x ~/dotfiles/bin/esxi-vm-create
	curl -sLo ~/dotfiles/bin/esxi-vm-destroy https://github.com/softasap/esxi-vm/blob/master/esxi-vm-destroy
	chmod +x ~/dotfiles/bin/esxi-vm-destroy
	curl -sLo ~/dotfiles/bin/esxi_vm_functions.py https://raw.githubusercontent.com/softasap/esxi-vm/master/esxi_vm_functions.py

install-esxi-govc:
	curl -L https://github.com/vmware/govmomi/releases/download/v0.21.0/govc_linux_amd64.gz | gunzip > ~/dotfiles/bin/govc
# /ESXI

fonts-swiss-knife: fonts-init fonts-awesome-terminal-fonts fonts-source-code-pro-patched
	mkdir -p ~/.fonts

fonts-init:
	sudo apt install fontconfig

fonts-awesome-terminal-fonts:
	mkdir -p ~/.fonts
	curl -sLo ~/.fonts/devicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/devicons-regular.sh"
	curl -sLo ~/.fonts/devicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/devicons-regular.ttf"
	curl -sLo ~/.fonts/fontawesome-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/fontawesome-regular.sh"
	curl -sLo ~/.fonts/fontawesome-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/fontawesome-regular.ttf"
	curl -sLo ~/.fonts/octicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/octicons-regular.sh"
	curl -sLo ~/.fonts/octicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/octicons-regular.ttf"
	curl -sLo ~/.fonts/pomicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/pomicons-regular.sh"
	curl -sLo ~/.fonts/pomicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/pomicons-regular.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "FontAwesome"

fonts-source-code-pro:
	mkdir -p ~/.fonts
	curl -sLo ~/.fonts/SourceCodeVariable-Italic.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.otf"
	curl -sLo ~/.fonts/SourceCodeVariable-Italic.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.ttf"
	curl -sLo ~/.fonts/SourceCodeVariable-Roman.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.otf"
	curl -sLo ~/.fonts/SourceCodeVariable-Roman.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code Pro"
fonts-source-code-pro-patched:
	mkdir -p ~/.fonts
	curl -sLo ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf"
	curl -sLo ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf"
	curl -sLo ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf"
	curl -sLo ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code"

z-clean-downloads:
	rm ~/Downloads/*.rdp


# LAPTOP
# Free terminal based CPU monitoring tool for Linux
throttling-stui:
	sudo pip install s-tui

install-vmware-ovftool:
	curl -sLo /tmp/ovftool.bundle https://raw.githubusercontent.com/smarunich/avitoolbox/master/files/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle
	md5sum /tmp/ovftool.bundle
	@echo d0dd9006d720a26278b94591a4111457   ovftool.bundle
	chmod +x /tmp/ovftool.bundle
	echo sudo /tmp/ovftool.bundle --eulas-agreed --required --console

# interactive https proxy https://mitmproxy.org/
install-mitmproxy-org:
	curl -sLo /tmp/mitmproxy.tar.gz https://snapshots.mitmproxy.org/4.0.4/mitmproxy-4.0.4-linux.tar.gz
	tar -xvzf /tmp/mitmproxy.tar.gz -C ~/dotfiles/bin


# /LAPTOP


# AWS

#https://aws.amazon.com/serverless/sam/
install-aws-sam-cli:
	pip install --user aws-sam-cli

#https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux
install-aws-session-manager-plugin:
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
	sudo dpkg -i session-manager-plugin.deb

# /AWS

# SECURITY

sec-nmap-sandmap:
	sudo apt-get install proxychains
	rm -rf /tmp/sandmap && cd /tmp && git clone --recursive https://github.com/trimstray/sandmap
	cd /tmp/sandmap && sudo ./setup.sh install
	echo use sandmap
# /SECURITY


# DOCUMENTATION

# https://www.mkdocs.org/
install-mkdocs:
	pip install mkdocs

# Small markdown to confluence
install-confluence-mark:
	curl -sLo /tmp/confluencemark.tar.gz https://github.com/kovetskiy/mark/releases/download/3.1/mark_3.1_Linux_x86_64.tar.gz
	tar -xvzf /tmp/confluencemark.tar.gz -C /tmp
	cp /tmp/mark ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/mark

#/ DOCUMENTATION

# GARBAGE

install-traefik1:
	curl -sLo ~/dotfiles/bin/traefik1 https://github.com/containous/traefik/releases/download/v1.7.19/traefik_linux-amd64
	chmod +x ~/dotfiles/bin/traefik1

install-traefik:
	curl -sLo /tmp/traefik2.tar.gz https://github.com/containous/traefik/releases/download/v2.1.1/traefik_v2.1.1_linux_amd64.tar.gz
	tar -xvzf /tmp/traefik2.tar.gz -C /tmp
	mv /tmp/traefik ~/dotfiles/bin/traefik
	chmod +x ~/dotfiles/bin/traefik

# / GARBAGE

# PHP

install-phpmd:
	curl -sLo ~/dotfiles/bin/phpmd https://phpmd.org/static/latest/phpmd.phar
	chmod +x ~/dotfiles/bin/phpmd

install-php-symphony-cli:
	curl -sLo /tmp/symfony.gz https://github.com/symfony/cli/releases/download/v4.18.4/symfony_linux_amd64.gz
	gunzip /tmp/symfony.gz
	mv /tmp/symfony ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/symfony
# /PHP


# RUNS

run-octant-remote:
	octant --listener-addr 0.0.0.0:7777

# Database modelling tools

install-dbtools-terra-er:
	curl -sLo ~/dotfiles/bin/terra.jar https://github.com/rterrabh/TerraER/releases/download/TerraER3.11/TerraER3.11.jar

install-dbtools-schemaspy:
	curl -sLo ~/dotfiles/bin/schemaspy.jar https://github.com/schemaspy/schemaspy/releases/download/v6.1.0/schemaspy-6.1.0.jar

install-dbtools-dbml-cli-npm:
	which npm
	npm install -g @dbml/cli
	echo dbml2sql schema.dbml
	echo dbml2sql schema.dbml --mysql
	echo "dbml2sql <path-to-dbml-file> [--mysql|--postgres] [-o|--out-file <output-filepath>]"
	echo sql2dbml dump.sql --postgres
	echo sql2dbml --mysql dump.sql -o mydatabase.dbml
	echo sql2dbml <path-to-sql-file> [--mysql|--postgres] [-o|--out-file <output-filepath>]


```

# Terraform versions

As your projects are based on different terraform versions, makes sense to isolate your terraform
version exactly as you isolate python, nodejs, go versions.

Thus if .terraform-version is detected in $HOME, it is assumed that this host has preference of using
terraform versions via tfenv, rather than using binary from ~/dotfiles/bin.

Terraform version is detected using following logic: if no parameter is passed, the version to use is
resolved automatically via .terraform-version files or TFENV_TERRAFORM_VERSION environment variable
(TFENV_TERRAFORM_VERSION takes precedence), defaulting to 'latest' if none are found.

Thus good idea is to set default version of the terraform.

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


# Deep Perversions

Mac look for ubuntu boxes

1. Dependencies
```
sudo apt-get install gtk2-engines-murrine gtk2-engines-pixbuf
sudo apt install gnome-shell-extensions
```

later enable user themes extensions

2. Download theme itself

https://www.gnome-look.org/p/1275087/

```
mkdir -p ~/.themes
```

3. Install icons set, saying

https://github.com/keeferrourke/la-capitaine-icon-theme

```
mkdir -p ~/.icons
cd ~/.icons
git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git
./configure
```

4. Using gnome tweaking tool change current theme and icon pack


# Working with workplaces

If you appear to be working with multiple independent tasks, you can ask alt-tab to switch only through windows in current workplace only

```sh
gsettings set org.gnome.shell.app-switcher current-workspace-only true
```

set to false if it does not suite your work habits

# Fingerprints

```
sudo apt remove fprintd
#Add the python-validity PPA
sudo add-apt-repository ppa:uunicorn/open-fprintd
sudo apt-get update
#Install python-validity and dependencies
sudo apt install open-fprintd fprintd-clients python3-validity
#Enroll a fingerprint
fprintd-enroll -f fprintd-enroll -f right-index-finger
#Enable fingerprint login
sudo pam-auth-update
```


# Notifications

## slack

Using slacktee

Configuration
Before start using slacktee, please set following variables in the script configuration file.
slacktee reads the global configuration (/etc/slacktee.conf) first, then reads your local configuration (~/.slacktee).
You can set up your local configuration file using interactive setup mode (--setup option).

You would need an authentication token for slacktee. It could be generated in 2 ways:

Crate a Slack App (Preffered by Slack, but a bit complicated to setup)
Follow steps listed in creating a Slack App.

Next, create a bot user for your app, give the following 3 permissions to the Bot Token Scopes of your app: chat:write, chat:write:public, files:write.
More information about the permission scopes can be found at permission scopes. [Note] Even with files:write permission, Slack App can upload files only to the channels
where the Slack App is in. So, please add your Slack App to the channels where you want to upload files. At last, install the app to your workplace and get the Bot User
OAuth token in the "OAuth & Permissions" section of the app management page.

Add a bot (Easy to setup, but Slack may remove it in future)

Add a bot into your workspace through Slack App Directory. You can now find 'API Token' in the configuration page of the bot.

token=""            # The authentication token of the bot user. Used for accessing Slack APIs.
channel=""          # Default channel to post messages. '#' is prepended, if it doesn't start with '#' or '@'.
tmp_dir="/tmp"      # Temporary file is created in this directory.
username="slacktee" # Default username to post messages.
icon="ghost"        # Default emoji or a direct url to an image to post messages. You don't have to wrap emoji with ':'. See http://www.emoji-cheat-sheet.com.
attachment=""       # Default color of the attachments. If an empty string is specified, the attachments are not used.


## Precommit hooks

```sh
pip3 install pre-commit
```

```sh
DIR=~/.git-template
git config --global init.templateDir ${DIR}
pre-commit init-templatedir -t pre-commit ${DIR}
````

 Add configs and hooks

Step into the repository you want to have the pre-commit hooks installed and run, for example

```sh
cat <<EOF > .pre-commit-config.yaml
repos:
- repo: git://github.com/antonbabenko/pre-commit-terraform
  rev: <VERSION> # Get the latest from: https://github.com/antonbabenko/pre-commit-terraform/releases
  hooks:
    - id: terraform_fmt
    - id: terraform_docs
EOF
```

Automatic hooks can be installed with

```sh
pre-commit install
```

while manual hooks run can be applied using

```sh
pre-commit run -a
```

## Running emails from the system using gmail smtp

On ubuntu system is possible using s-mail utility.

Dirty way

```sh
s-mail -v -s "$EMAIL_SUBJECT" \
-S smtp-use-starttls \
-S ssl-verify=ignore \
-S smtp-auth=login \
-S smtp=smtp://smtp.gmail.com:587 \
-S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" \
-S smtp-auth-user=$FROM_EMAIL_ADDRESS \
-S smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD \
-S ssl-verify=ignore \
$TO_EMAIL_ADDRESS
```

i.e.   `echo "The mail content" | s-mail -v -s ...`

You would need to use app password  https://myaccount.google.com/apppasswords, rather than real gmail account password.

More compact way is to  use s-mail configuration file '~/.mailrc'

```
set smtp-use-starttls
set ssl-verify=ignore
set smtp=smtp://smtp.gmail.com:587
set smtp-auth=login
set smtp-auth-user=$FROM_EMAIL_ADDRESS
set smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD
set from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)"
```

`chmod 600 ~/.mailrc.`

The variables set are the same as those used in the "all in one command".

When sending mails, use this command:

$ s-mail -v -s "$EMAIL_SUBJECT" $TO_EMAIL_ADDRESS
Or

$ echo "The mail content" | s-mail -v -s "$EMAIL_SUBJECT" $TO_EMAIL_ADDRESS


#### To test your anonymity:
<details><summary>Expand for anonymity test</summary>
<br>

* [Check My IPx](https://ipx.ac/)
* [Check Tor Project](https://check.torproject.org)
* [Do I leak](http://www.doileak.com/)
* [DNS leak test](http://dnsleaktest.com)
* [Test IPv6](http://ipv6-test.com/)
* [What is my proxy](http://whatismyproxy.com)
* [What every Browser knows about you](http://webkay.robinlinus.com/)
* [Proxy check on proxydb](http://proxydb.net/anon)

</details>


## pdf perks

```sh
ls -1 ./*jpg | xargs -L1 -I {} img2pdf {} -o {}_raw.pdf

ls -1 ./*_raw.pdf | xargs -L1 -I {} ocrmypdf {} {}_ocr.pdf

```

## Remapping win key

You can re-map everything to Win key with xcape by re-assigning any other key combination

```
xcape -e 'Super_L=Shift_L|Escape'
```

## Pinning kubectl, helm, kustomize versions, etc

Install asdf in your environment via Makefile ;

Ensure you've initialized integration with global direnv and you have direnv installed globally

```sh
asdf plugin add direnv
```

Consider installing supported plugins

```sh
asdf plugin add kustomize
asdf plugin add helmfile
asdf plugin add kubectl
asdf plugin add helm
```

IF you have disabled tfenv integration, you could also add terraform as plugin

```sh
asdf plugin add terraform
```

Create two files in your "project" root:

on top of your envrc:

```
use asdf
```

and after that you can use .tools-versions file, kind of

```
terraform 1.0.7
kustomize 3.5.3
kubectl 1.20.2
```
EOF

## Current set of gnome extensions in use

```
gnome-extensions list --enabled

ddterm@amezin.github.com
dynamic-panel-transparency@rockon999.github.io
putWindow@clemens.lab21.org
workspace-switch-wraparound@theychx.org
dash-to-dock@micxgx.gmail.com
system-monitor@paradoxxx.zero.gmail.com
gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com
status-area-horizontal-spacing@mathematical.coffee.gmail.com
ubuntu-appindicators@ubuntu.com
apps-menu@gnome-shell-extensions.gcampax.github.com
auto-move-windows@gnome-shell-extensions.gcampax.github.com
user-theme@gnome-shell-extensions.gcampax.github.com
workspace-indicator@gnome-shell-extensions.gcampax.github.com


```

## Disallow ubuntu to switch audio sources

File: /etc/pulse/default.pa

```
### Should be after module-*-restore but before module-*-detect
#[VS] 1 below
# load-module module-switch-on-port-available

### Use hot-plugged devices like Bluetooth or USB automatically (LP: #1702794)
#[VS] 3 below
#.ifexists module-switch-on-connect.so
#load-module module-switch-on-connect
#.endif
```



## 3rd party work

Contains portions of bash library modules released under

This code is released under the Apache 2.0 License. Please see
[LICENSE](https://github.com/gruntwork-io/bash-commons/tree/master/LICENSE) and
[NOTICE](https://github.com/gruntwork-io/bash-commons/tree/master/NOTICE) for more details.


Contains portions of the zsh prompt framework
https://github.com/Powerlevel9k/powerlevel9k

This code is released under MIT license , as can be found on
https://github.com/Powerlevel9k/powerlevel9k/blob/master/LICENSE

Bash completions

https://github.com/scop/bash-completion

## Changing colors for ls command

Credits to http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors

```sh
for i in 00{2..8} {0{3,4,9},10}{0..7}
do echo -e "$i \e[0;${i}mSubdermatoglyphic text\e[00m  \e[1;${i}mSubdermatoglyphic text\e[00m"
done

for i in 00{2..8} {0{3,4,9},10}{0..7}
do for j in 0 1
   do echo -e "$j;$i \e[$j;${i}mSubdermatoglyphic text\e[00m"
   done
done
```

LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS
Some nice color choices (in this case 0;35 it is purple) are:

```
Blue = 34
Green = 32
Light Green = 1;32
Cyan = 36
Red = 31
Purple = 35
Brown = 33
Yellow = 1;33
Bold White = 1;37
Light Grey = 0;37
Black = 30
Dark Grey= 1;30
```

The first number is the style (1=bold), followed by a semicolon, and then the actual number of the color, possible styles (effects) are:

```
0   = default colour
1   = bold
4   = underlined
5   = flashing text (disabled on some terminals)
7   = reverse field (exchange foreground and background color)
8   = concealed (invisible)
```

The possible backgrounds:

```
40  = black background
41  = red background
42  = green background
43  = orange background
44  = blue background
45  = purple background
46  = cyan background
47  = grey background
100 = dark grey background
101 = light red background
102 = light green background
103 = yellow background
104 = light blue background
105 = light purple background
106 = turquoise background
107 = white background
```

All possible colors:

```
30  = black
31  = red
32  = green
33  = orange
34  = blue
35  = purple
36  = cyan
37  = grey
90  = dark grey
91  = light red
92  = light green
93  = yellow
94  = light blue
95  = light purple
96  = turquoise
97  = white
```
These can even be combined, so that a parameter like:

```
di=1;4;31;42
```
in your LS_COLORS variable would make directories appear in bold underlined red text with a green background!

```
You can also change other kinds of files when using the ls command by defining each kind with:

bd = (BLOCK, BLK)   Block device (buffered) special file
cd = (CHAR, CHR)    Character device (unbuffered) special file
di = (DIR)  Directory
do = (DOOR) [Door][1]
ex = (EXEC) Executable file (ie. has 'x' set in permissions)
fi = (FILE) Normal file
ln = (SYMLINK, LINK, LNK)   Symbolic link. If you set this to ‘target’ instead of a numerical value, the color is as for the file pointed to.
mi = (MISSING)  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
no = (NORMAL, NORM) Normal (non-filename) text. Global default, although everything should be something
or = (ORPHAN)   Symbolic link pointing to an orphaned non-existent file
ow = (OTHER_WRITABLE)   Directory that is other-writable (o+w) and not sticky
pi = (FIFO, PIPE)   Named pipe (fifo file)
sg = (SETGID)   File that is setgid (g+s)
so = (SOCK) Socket file
st = (STICKY)   Directory with the sticky bit set (+t) and not other-writable
su = (SETUID)   File that is setuid (u+s)
tw = (STICKY_OTHER_WRITABLE)    Directory that is sticky and other-writable (+t,o+w)
*.extension =   Every file using this extension e.g. *.rpm = files with the ending .rpm
```


## Hardware case thingy

Always have active pair of keys registered on services, and perhaps 3rd in unpacked form for quickly replacement
Try not forget your PINs, consider applying same pins on both pairs.

Perhaps have registry of portals where you have registered your keys, to speedup future key rotation

### Necessary packets and hacks

You might need:
```sh
sudo apt-get -y install swig
sudo apt install libpcsclite-dev
sudo apt install pcscd
```

### Resetting openpgp fault pin count

```sh
# you might be forced to change config mode for ykman
ykman config mode ccid
ykman openpgp access set-retries 3 3 3
```

As a result of operation both pins will be reset to defaults, so do not forget to change back


### Generating ssh keys requiring smart card physical presence

#### Undiscoverable key

Such key would require presence of the device and physical authorising, but if you would lost private key of file (saying, moved to new PC)
you would need to copy it separately or generate new

```sh
ssh-keygen -t ed25519-sk -C "hardware_smart_card_black2_verify_required" -O verify-required
```

#### Discoverable key

```sh
ssh-keygen -t ed25519-sk -O resident -O verify-required -O application=ssh:hardware_resident_key
```

This works the same as before, except a resident key is easier to import to a new computer because it can be loaded directly from the security key.
To use the SSH key on a new computer, make sure you have ssh-agent running and simply run:

```sh
ssh-add -K
```

This will load a “key handle” into the SSH agent and make the key available for use on the new computer. This works great for short visits, but it won’t last forever – you’ll
need to run ssh-add again if you reboot the computer, for example. To import the key permanently, instead run:

```sh
ssh-keygen -K
```

This will write two files into the current directory: id_ed25519_sk_rk_hardware_resident_key   id_ed25519_sk_rk_hardware_resident_key.pub. Naming comes from -O application=ssh:KEYNAME,
so good idea to provide short clear name when you generate the key.

Now you just need to it into your SSH directory.


Additional bonuses:

Both options guarantee that even if that private file (reference to smartcard) is stolen from your PC, intruder still won't be able to use ssh key to login to external machine
without physical smart card.  Non-discoverable option would ensure, that if your smart card is stolen, intruder also won't be able to generate original private key reference to smartcard, even if he would guess your pin before lock on 8th try. (edited)

additional pro - you can add same key as a MFA device on aws login (so not a phone, some app on your laptop - but physical thingy you need to have)

and final pro - as most of the people have aws credentials in ~/.aws/credentials|config files  - it is also possible to ensure, that when one tries to use aws credentials
(which are supposed to be rotated +- regular anyway) - that person has access to physical smart card - thus mitigate risk of stolen aws credentials too.


CONS: this is hardware device - capacity sensor might stop working, your could have some static electricity inserting into port, and so on.
Thus you always need to have two pre-configured in a similar manner keys , and perhaps third for easy replacement.

## UI Albert launcher

### Remap windows key hack

install xcape, and add remapper to auto startup programs.
You can find auto startup programs dialog by launching
`gnome-session-properties`

```sh
xcape -e 'Super_L=Control_L|F1'
```



###

## dot-version thingies
### .python-version

That's the file handled by pyenv.
First step - you can choose specific python version
```sh
pyenv install --list | grep " 3\.[678]"
pyenv install -v 3.7.2
```

If you are lucky enough, and can share environment between projects - you can just put v3.7.2 into this file.
```
v3.7.2
```

Otherwise you are about to proceed with virtualenv

```sh
pyenv virtualenv <python_version> <environment_name>
```

and put the name of virtual environment into same file
```
my-project-virtualenv
```

### .nvmrc

That's file handled by nvm. Just put node version in it
```
v18.15.0
```

You might want to install node version first
```sh
nvm install v18.15.0
```

### .terraform-version

Thats file is handled by tfenv and specifies version of the terraform that is in use in the current project

```
1.0.2
```

### .java-version

That is file handled by jenv

```
17.0.8.1
```

You might want to install javasdk, and register it with jenv first.

```sh
jenv add /usr/lib/jvm/java-17-amazon-corretto/
```
