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

# jsonnet processing tool
install-console-jsonnet: install-console-yq
	wget -O /tmp/jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v0.14.0/jsonnet-bin-v0.14.0-linux.tar.gz
	tar -xvzf /tmp/jsonnet.tar.gz -C /tmp
	cp /tmp/jsonnet ~/dotfiles/bin
	cp /tmp/jsonnetfmt ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/jsonnet ~/dotfiles/bin/jsonnetfmt

install-mysql-skeema:
	wget -O /tmp/skeema.tar.gz https://github.com/skeema/skeema/releases/download/v1.4.2/skeema_1.4.2_linux_amd64.tar.gz
	tar -xvzf /tmp/skeema.tar.gz -C /tmp
	cp /tmp/skeema ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/skeema

install-mysql-dbmate:
	wget -O ~/dotfiles/bin/dbmate https://github.com/amacneil/dbmate/releases/download/v1.7.0/dbmate-linux-amd64
	chmod +x ~/dotfiles/bin/dbmate

# cat with syntax highlight https://github.com/sharkdp/bat
install-console-bat:
	wget -O /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

# https://github.com/jesseduffield/lazygit
install-console-lazygit:
	wget -O /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.20.4/lazygit_0.20.4_Linux_x86_64.tar.gz
	tar -xvzf /tmp/lazygit.tar.gz -C /tmp
	mv /tmp/lazygit ~/dotfiles/bin

# http://lnav.org/
install-console-logreader-lnav:
	wget -O /tmp/lnav.zip https://github.com/tstack/lnav/releases/download/v0.8.5/lnav-0.8.5-linux-64bit.zip
	cd /tmp && unzip lnav.zip
	mv /tmp/lnav-0.8.5/lnav ~/dotfiles/bin
	lnav -i extra

# https://github.com/rcoh/angle-grinder#query-syntax
install-console-logreader-agrind:
	wget -O /tmp/agrind.tar.gz https://github.com/rcoh/angle-grinder/releases/download/v0.13.0/angle_grinder-v0.13.0-x86_64-unknown-linux-musl.tar.gz
	tar -xvzf /tmp/agrind.tar.gz -C /tmp
	cp /tmp/agrind ~/dotfiles/bin/ag
	chmod +x ~/dotfiles/bin/ag

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

# WTF is a personal information dashboard for your terminal, developed for those who spend most of their day in the command line.
install-console-wtfutil:
	wget -O /tmp/wtf.tar.gz https://github.com/wtfutil/wtf/releases/download/v0.30.0/wtf_0.30.0_linux_amd64.tar.gz
	tar -xvzf /tmp/wtf.tar.gz -C /tmp
	cp /tmp/wtf_0.30.0_linux_amd64/wtfutil ~/dotfiles/bin/wtfutil
	chmod +x ~/dotfiles/bin/wtfutil

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

# /WORKSPACE TOOLS


# DOCKER TOOLS


install-docker-machine:
	wget -O ~/dotfiles/bin/docker-machine https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-Linux-x86_64
	chmod +x ~/dotfiles/bin/docker-machine

# docker console manager
install-docker-dry:
	wget -O ~/dotfiles/bin/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/bin/dry

install-docker-dive:
	wget -O /tmp/dive.deb https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
	sudo apt install /tmp/dive.deb

# https://dockersl.im
install-docker-slim:
	wget -O /tmp/docker-slim.tar.gz https://downloads.dockerslim.com/releases/1.29.0/dist_linux.tar.gz
	tar -xvzf /tmp/docker-slim.tar.gz -C /tmp
	mv /tmp/dist_linux/* ~/dotfiles/bin

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
	wget -O ~/dotfiles/bin/k3sup https://github.com/alexellis/k3sup/releases/download/0.9.2/k3sup
	chmod +x ~/dotfiles/bin/k3sup

install-k8s-ksonnet:
	wget -O /tmp/ks_linux_amd64.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v0.10.1/ks_0.10.1_linux_amd64.tar.gz
	tar -xvzf /tmp/ks_linux_amd64.tar.gz -C /tmp
	cp /tmp/ks_0.10.1_linux_amd64/ks ~/dotfiles/bin

install-k8s-stern:
	wget -O ~/dotfiles/bin/stern "https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64"
	chmod +x ~/dotfiles/bin/stern

install-k8s-helm3-fixed:
	mkdir -p /tmp/helm
	wget -O /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-v3.1.0-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
	rm -rf /tmp/helm


install-k8s-helm-latest:
	mkdir -p /tmp/helm
	wget -O /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-$(shell curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
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
	wget -O /tmp/kubefwd.deb https://github.com/txn2/kubefwd/releases/download/1.12.0/kubefwd_amd64.deb
	sudo apt install /tmp/kubefwd.deb

# https://github.com/instrumenta/kubeval/
install-k8s-kubeval:
	wget -O /tmp/kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/0.14.0/kubeval-linux-amd64.tar.gz
	tar -xvzf /tmp/kubeval.tar.gz -C /tmp
	cp /tmp/kubeval ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/kubeval

# https://github.com/vmware-tanzu/octant/
# Kubernetes dashboard by VMWare
install-k8s-vmware-octant:
	wget -O /tmp/octant.deb https://github.com/vmware-tanzu/octant/releases/download/v0.10.2/octant_0.10.2_Linux-64bit.deb
	sudo apt install /tmp/octant.deb
	echo use octant --listener-addr 0.0.0.0:7777 to listen remotely	

# https://github.com/corneliusweig/rakkess
# Review Access - kubectl plugin to show an access matrix for k8s server resources
install-k8s-rakkess:
	curl -Lo /tmp/rakkess.gz https://github.com/corneliusweig/rakkess/releases/download/v0.4.1/rakkess-linux-amd64.gz && \
	cd /tmp && gunzip rakkess.gz && chmod +x rakkess && mv rakkess ~/dotfiles/bin

# https://github.com/derailed/popeye
# A Kubernetes cluster resource sanitizer
install-k8s-popeye:
	wget -O /tmp/popeye.tar.gz https://github.com/derailed/popeye/releases/download/v0.6.2/popeye_0.6.2_Linux_x86_64.tar.gz
	tar -xvzf /tmp/popeye.tar.gz -C /tmp
	cp /tmp/popeye ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/popeye

#  https://github.com/FairwindsOps/polaris
#  Validation of best practices in your Kubernetes clusters https://www.fairwinds.com/polaris
install-k8s-polaris:
	wget -O /tmp/polaris.tar.gz https://github.com/FairwindsOps/polaris/releases/download/0.6.0/polaris_0.6.0_Linux_x86_64.tar.gz
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
	wget -O /tmp/kubespy.tar.gz https://github.com/pulumi/kubespy/releases/download/v0.5.0/kubespy-linux-amd64.tar.gz
	tar -xvzf /tmp/kubespy.tar.gz -C /tmp
	cp /tmp/releases/kubespy-linux-amd64/kubespy ~/dotfiles/bin
	ln -s ~/dotfiles/bin/kubespy  ~/dotfiles/bin/kubectl-spy

# https://skaffold.dev/
install-k8s-skaffold:
	curl -Lo ~/dotfiles/bin/skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
	chmod +x ~/dotfiles/bin/skaffold


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
	wget -O ~/dotfiles/bin/terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)/terraform-docs-$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64
	chmod +x ~/dotfiles/bin/terraform-docs

install-terraform-virtualbox-bridge:
	go get github.com/terra-farm/terraform-provider-virtualbox
	mkdir -p ~/.terraform.d/plugins
	cp $(GOPATH)/bin/terraform-provider-virtualbox ~/.terraform.d/plugins

install-terraform-tfschema:
	wget -O /tmp/tfschema.tar.gz https://github.com/minamijoyo/tfschema/releases/download/v0.3.0/tfschema_0.3.0_linux_amd64.tar.gz
	tar -xvzf /tmp/tfschema.tar.gz -C /tmp
	cp /tmp/tfschema ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/tfschema

# interactive d3js-graphviz visualization for terraform graph (beta)
install-terraform-blast:
	pip install blastradius

install-tflint:
	wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/$(shell curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep tag_name | cut -d '"' -f 4)/tflint_linux_amd64.zip
	cd /tmp && unzip tflint.zip
	mv /tmp/tflint ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/tflint
# /TERRAFORM


# HASHICORP
install-hashicorp-vault:
	wget -O ~/dotfiles/bin/vault.zip "https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip vault.zip && chmod +x vault && rm vault.zip

install-hashicorp-terraform011:
	wget -O ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform011 && chmod +x terraform011 && rm terraform.zip && mv terraform011 ~/dotfiles/bin/


install-hashicorp-terraform012:
	wget -O ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-hashicorp-terraform:
	wget -O ~/dotfiles/bin/terraform.zip "https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip

install-hashicorp-packer:
	wget -O ~/dotfiles/bin/packer.zip "https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip"
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
	wget -O /tmp/myaws.tar.gz https://github.com/minamijoyo/myaws/releases/download/v0.3.10/myaws_v0.3.10_linux_amd64.tar.gz
	tar -xvzf /tmp/myaws.tar.gz -C ~/dotfiles/bin

install-aws-awless:
	wget -O /tmp/awless.tar.gz https://github.com/wallix/awless/releases/download/v0.1.11/awless-linux-amd64.tar.gz
	tar -xvzf /tmp/awless.tar.gz -C ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/awless

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
install-aws-cli2:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
	cd /tmp && unzip awscliv2.zip
	cd /tmp && sudo ./aws/install

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

install-esxi-govc:
	curl -L https://github.com/vmware/govmomi/releases/download/v0.21.0/govc_linux_amd64.gz | gunzip > ~/dotfiles/bin/govc
# /ESXI

fonts-swiss-knife: fonts-init fonts-awesome-terminal-fonts fonts-source-code-pro-patched
	mkdir -p ~/.fonts

fonts-init:
	sudo apt install fontconfig

fonts-awesome-terminal-fonts:
	mkdir -p ~/.fonts
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
	mkdir -p ~/.fonts
	wget -O ~/.fonts/SourceCodeVariable-Italic.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.otf"
	wget -O ~/.fonts/SourceCodeVariable-Italic.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.ttf"
	wget -O ~/.fonts/SourceCodeVariable-Roman.otf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.otf"
	wget -O ~/.fonts/SourceCodeVariable-Roman.ttf "https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code Pro"
fonts-source-code-pro-patched:
	mkdir -p ~/.fonts
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Mono.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete_Windows_Compatible.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf"
	wget -O ~/.fonts/Sauce_Code_Pro_Nerd_Font_Complete.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf"
	fc-cache -fv ~/.fonts
	fc-list | grep "Source Code"

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

# interactive https proxy https://mitmproxy.org/
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
	wget -O /tmp/confluencemark.tar.gz https://github.com/kovetskiy/mark/releases/download/3.1/mark_3.1_Linux_x86_64.tar.gz
	tar -xvzf /tmp/confluencemark.tar.gz -C /tmp
	cp /tmp/mark ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/mark

#/ DOCUMENTATION

# GARBAGE

install-traefik1:
	wget -O ~/dotfiles/bin/traefik1 https://github.com/containous/traefik/releases/download/v1.7.19/traefik_linux-amd64
	chmod +x ~/dotfiles/bin/traefik1

install-traefik:
	wget -O /tmp/traefik2.tar.gz https://github.com/containous/traefik/releases/download/v2.1.1/traefik_v2.1.1_linux_amd64.tar.gz
	tar -xvzf /tmp/traefik2.tar.gz -C /tmp
	mv /tmp/traefik ~/dotfiles/bin/traefik
	chmod +x ~/dotfiles/bin/traefik

# / GARBAGE

# PHP

install-phpmd:
	wget -O ~/dotfiles/bin/phpmd https://phpmd.org/static/latest/phpmd.phar
	chmod +x ~/dotfiles/bin/phpmd

install-php-symphony-cli:
	wget -O /tmp/symfony.gz https://github.com/symfony/cli/releases/download/v4.18.4/symfony_linux_amd64.gz
	gunzip /tmp/symfony.gz
	mv /tmp/symfony ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/symfony
# /PHP


# RUNS

run-octant-remote:
	octant --listener-addr 0.0.0.0:7777
