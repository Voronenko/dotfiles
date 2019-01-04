swiss-knife: install-console-prettytyping install-console-fzf install-console-diffsofancy install-docker-dry zsh-fzf install-hashicorp-terraform install-aws-key-importer
	@echo OK

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

install-console-bat:
	wget -O /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

install-console-prettytyping:
	wget -O ~/dotfiles/docker/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
	chmod +x ~/dotfiles/docker/prettyping

install-docker-machine:
	wget -O ~/dotfiles/docker/docker-machine https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-Linux-x86_64
	chmod +x ~/dotfiles/docker/docker-machine

# https://github.com/junegunn/fzf
install-console-fzf:
	wget -O /tmp/fzf.tar.gz https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz
	tar -xvzf /tmp/fzf.tar.gz -C /tmp
	cp /tmp/fzf ~/dotfiles/docker
	echo "Consider running make zsh-fzf to install zsh shell integration"

# https://github.com/so-fancy/diff-so-fancy
install-console-diffsofancy:
	wget -O ~/dotfiles/docker/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x ~/dotfiles/docker/diff-so-fancy


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

install-console-toggle-cli:
	mkdir -p ~/apps
	git clone git@github.com:drobertadams/toggl-cli.git ~/apps/toggle-cli
	ln -s ~/apps/toggle-cli/toggl.sh ~/dotfiles/docker/toggl
	chmod +x ~/dotfiles/docker/toggl

install-console-ncdu:
	sudo apt-get install ncdu

install-k8s-ksonnet:
	wget -O /tmp/ks_linux_amd64.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v0.10.1/ks_0.10.1_linux_amd64.tar.gz
	tar -xvzf /tmp/ks_linux_amd64.tar.gz -C /tmp
	cp /tmp/ks_0.10.1_linux_amd64/ks ~/dotfiles/docker

install-k8s-stern:
	wget -O ~/dotfiles/docker/stern "https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64"
	chmod +x ~/dotfiles/docker/stern

install-k8s-helm:
	mkdir -p /tmp/helm
	wget -O /tmp/helm/helm.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/docker
	rm -rf /tmp/helm

install-docker-dry:
	wget -O ~/dotfiles/docker/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/docker/dry

install-deepmind-kapitan:
	pip3 install --user --upgrade git+https://github.com/deepmind/kapitan.git  --process-dependency-links

install-github-release:
	mkdir -p /tmp/gh-release
	wget -O /tmp/gh-release/linux-amd64-github-release.tar.bz2 "https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2"
	cd /tmp/gh-release && tar jxf linux-amd64-github-release.tar.bz2 && mv /tmp/gh-release/bin/linux/amd64/github-release ~/dotfiles/docker
	rm -rf /tmp/gh-release

install-k8s-heptio-authenticator-aws:
	curl -o ~/dotfiles/docker/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
	curl -o ~/dotfiles/docker/heptio-authenticator-aws.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws.md5
	chmod +x ~/dotfiles/docker/heptio-authenticator-aws

install-k8s-weaveworks-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl ~/dotfiles/docker

install-k8s-kubectl-ubuntu:
	sudo apt-get update && sudo apt-get install -y apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/kubernetes.list
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl

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


kube-dashboard-normal-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kube-dashboard-insecure-install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
	echo possible to grant admin via  kubectl create -f ~/dotfiles/docker/k8s/dashboard-admin.yaml
	echo run kubectl proxy followed with http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default


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

zsh-fzf:
	git clone https://github.com/junegunn/fzf.git ~/.oh-my-zsh/custom/plugins/fzf
	~/.oh-my-zsh/custom/plugins/fzf/install --bin
	mkdir -p ~/.oh-my-zsh/custom/plugins/fzf-zsh
	cp ~/dotfiles/helpers/fzf-zsh.plugin.zsh ~/.oh-my-zsh/custom/plugins/fzf-zsh

install-terraform-ing:
	gem install terraforming

install-terraform-docs:
	wget -O ~/dotfiles/docker/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v0.4.0/terraform-docs-v0.4.0-linux-amd64
	chmod +x ~/dotfiles/docker/terraform-docs

install-terraform-virtualbox-bridge:
	go get github.com/terra-farm/terraform-provider-virtualbox
	mkdir -p ~/.terraform.d/plugins
	cp $(GOPATH)/bin/terraform-provider-virtualbox ~/.terraform.d/plugins

install-hashicorp-vault:
	wget -O ~/dotfiles/docker/vault.zip "https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip"
	cd ~/dotfiles/docker/ && unzip vault.zip && chmod +x vault && rm vault.zip

install-hashicorp-terraform:
	wget -O ~/dotfiles/docker/terraform.zip "https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
	cd ~/dotfiles/docker/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-go-gimme:
	curl -sL -o ~/dotfiles/docker/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x ~/dotfiles/docker/gimme

go-rename:
	go get golang.org/x/tools/cmd/gorename

go-eg:
	go get golang.org/x/tools/cmd/eg

install-aws-key-importer:
	wget -O ~/dotfiles/docker/aws-key-importer https://github.com/Voronenko/aws-key-importer/releases/download/0.2.0/aws-key-importer-linux-amd64
	chmod +x ~/dotfiles/docker/aws-key-importer

install-aws-myaws:
	wget -O /tmp/myaws.tar.gz https://github.com/minamijoyo/myaws/releases/download/v0.3.3/myaws_v0.3.3_linux_amd64.tar.gz
	tar -xvzf /tmp/myaws.tar.gz -C ~/dotfiles/docker

install-ovh-nova:
	sudo pip install python-openstackclient

