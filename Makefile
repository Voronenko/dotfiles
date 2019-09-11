swiss-knife: install-console-prettytyping install-console-fzf install-console-diffsofancy install-docker-dry zsh-fzf install-hashicorp-terraform install-aws-key-importer
	@echo OK


# ZSH
zsh-fzf-repo:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
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

# cat with syntax highlight https://github.com/sharkdp/bat
install-console-bat:
	wget -O /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

# https://github.com/denilsonsa/prettyping
# prettyping 8.8.8.8
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

# fd is a simple, fast and user-friendly alternative to find. https://github.com/sharkdp/fd
# fd service
install-console-fd:
	wget -O /tmp/fd.deb https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
	sudo dpkg -i /tmp/fd.deb

# ripgrep recursively searches directories for a regex pattern https://github.com/BurntSushi/ripgrep
# rg -n -w '[A-Z]+_SUSPEND'
install-console-ripgrep:
	wget -O /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
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
	wget -O ~/dotfiles/bin/yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
	chmod +x ~/dotfiles/bin/yq

install-ngrok:
	wget -O ~/dotfiles/bin/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	cd ~/dotfiles/bin/ && unzip ngrok.zip
	rm ~/dotfiles/bin/ngrok.zip

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

install-direnv:
	wget -O ~/dotfiles/bin/direnv https://github.com/direnv/direnv/releases/download/v2.19.1/direnv.linux-amd64
	chmod +x ~/dotfiles/bin/direnv

https://github.com/direnv/direnv/releases/download/v2.19.1/direnv.linux-amd64
# /WORKSPACE TOOLS


# DOCKER TOOLS


install-docker-machine:
	wget -O ~/dotfiles/bin/docker-machine https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-Linux-x86_64
	chmod +x ~/dotfiles/bin/docker-machine

# docker console manager
install-docker-dry:
	wget -O ~/dotfiles/bin/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/bin/dry

# /DOCKER TOOLS


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

install-k8s-aws-iam-authenticator:
	curl -o ~/dotfiles/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator
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

kube-dashboard-normal-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kube-dashboard-insecure-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
	echo possible to grant admin via  kubectl create -f ~/dotfiles/bin/k8s/dashboard-admin.yaml
	echo run kubectl proxy followed with http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default

install-openshift-oc:
	wget -O /tmp/openshift.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
	tar -xvzf /tmp/openshift.tar.gz -C /tmp
	mv /tmp/openshift-origin-client-tools-*  /tmp/openshift-origin-client-tools
	cp /tmp/openshift-origin-client-tools/oc ~/dotfiles/bin
	type kubectl >/dev/null || /tmp/openshift-origin-client-tools/oc ~/dotfiles/bin
	echo "If there were no kubectl in path, one was installed from oc distro."
	echo "In other case global is used. Please check carefully"

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

# +plugins=(... alias-tips)
zsh-alias-tips:
	git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips


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
	wget -O ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-hashicorp-packer:
	wget -O ~/dotfiles/bin/packer.zip "https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip"
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

jenv:
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

# /JAVA

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

# ESXI
# https://github.com/softasap/esxi-vm
install-esxi-tools:
	wget -O ~/dotfiles/bin/esxi-vm-create https://raw.githubusercontent.com/softasap/esxi-vm/master/esxi-vm-create
	chmod +x ~/dotfiles/bin/esxi-vm-create
	wget -O ~/dotfiles/bin/esxi-vm-destroy https://github.com/softasap/esxi-vm/blob/master/esxi-vm-destroy
	chmod +x ~/dotfiles/bin/esxi-vm-destroy
	wget -O ~/dotfiles/bin/esxi_vm_functions.py https://raw.githubusercontent.com/softasap/esxi-vm/master/esxi_vm_functions.py
# /ESXI


fonts-awesome-terminal-fonts:
	wget -O ~/.fonts/devicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/devicons-regular.sh"
	wget -O ~/.fonts/devicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/devicons-regular.ttf"
	wget -O ~/.fonts/fontawesome-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/fontawesome-regular.sh"
	wget -O ~/.fonts/fontawesome-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/fontawesome-regular.ttf"
	wget -O ~/.fonts/octicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/octicons-regular.sh"
	wget -O ~/.fonts/octicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/octicons-regular.ttf"
	wget -O ~/.fonts/pomicons-regular.sh "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/pomicons-regular.sh"
	wget -O ~/.fonts/pomicons-regular.ttf "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/master/build/pomicons-regular.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "FontAwesome"

fonts-source-code-pro:
	wget -O ~/.fonts/SourceCodeVariable-Italic.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.otf"
	wget -O ~/.fonts/SourceCodeVariable-Italic.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.ttf"
	wget -O ~/.fonts/SourceCodeVariable-Roman.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.otf"
	wget -O ~/.fonts/SourceCodeVariable-Roman.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code Pro"
fonts-source-code-pro-patched:
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code Pro"

z-clean-downloads:
	rm ~/Downloads/*.rdp


# LAPTOP
# Free terminal based CPU monitoring tool for Linux
throttling-stui:
	sudo pip install s-tui

install-vmware-ovftool:
	wget -O /tmp/ovftool.bundle https://raw.githubusercontent.com/smarunich/avitoolbox/master/files/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle
	md5sum /tmp/ovftool.bundle
	@echo d0dd9006d720a26278b94591a4111457   ovftool.bundle
	chmod +x /tmp/ovftool.bundle
	echo sudo /tmp/ovftool.bundle --eulas-agreed --required --console

install-mitmproxy-org:
	wget -O /tmp/mitmproxy.tar.gz https://snapshots.mitmproxy.org/4.0.4/mitmproxy-4.0.4-linux.tar.gz
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
