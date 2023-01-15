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

install-zellij:
	curl -sLo /tmp/zellij.tar.gz https://github.com/zellij-org/zellij/releases/download/v$(shell curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c 2-)/zellij-x86_64-unknown-linux-musl.tar.gz
	tar -xvzf /tmp/zellij.tar.gz -C /tmp
	sudo mv /tmp/zellij /usr/local/bin
	sudo chmod +x /usr/local/bin/zellij

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
	curl -sLo /tmp/jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz
	tar -xvzf /tmp/jsonnet.tar.gz -C /tmp
	cp /tmp/jsonnet ~/dotfiles/bin
	cp /tmp/jsonnetfmt ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/jsonnet ~/dotfiles/bin/jsonnetfmt

# jsonnet bundler
install-console-jb:
	curl -sLo ~/dotfiles/bin/jb https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.4.0/jb-linux-amd64
	chmod +x ~/dotfiles/bin/jb

install-mysql-skeema:
	curl -sLo /tmp/skeema.tar.gz https://github.com/skeema/skeema/releases/download/v1.4.7/skeema_1.4.7_linux_amd64.tar.gz
	tar -xvzf /tmp/skeema.tar.gz -C /tmp
	cp /tmp/skeema ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/skeema

install-mysql-dbmate:
	curl -sLo ~/dotfiles/bin/dbmate https://github.com/amacneil/dbmate/releases/download/v1.11.0/dbmate-linux-amd64
	chmod +x ~/dotfiles/bin/dbmate

# cat with syntax highlight https://github.com/sharkdp/bat
install-console-bat:
	curl -sLo /tmp/bat_0.6.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.6.0_amd64.deb

install-console-lazysuite: install-console-lazygit install-console-lazydocker install-console-lazycli
	echo "Done"

# https://github.com/jesseduffield/lazygit
install-console-lazygit:
	curl -sLo /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.36.0/lazygit_0.36.0_Linux_x86_64.tar.gz
	tar -xvzf /tmp/lazygit.tar.gz -C /tmp
	mv /tmp/lazygit ~/dotfiles/bin

install-console-lazydocker:
	curl -sLo /tmp/lazydocker.tar.gz https://github.com/jesseduffield/lazydocker/releases/download/v0.20.0/lazydocker_0.20.0_Linux_x86.tar.gz
	tar -xvzf /tmp/lazydocker.tar.gz -C /tmp
	mv /tmp/lazydocker ~/dotfiles/bin

install-console-lazycli:
	curl -sLo /tmp/lazycli.tar.gz https://github.com/jesseduffield/lazycli/releases/download/v0.1.15/lazycli-linux-x64.tar.gz
	tar -xvzf /tmp/lazycli.tar.gz -C /tmp
	mv /tmp/lazycli ~/dotfiles/bin

# http://lnav.org/
install-console-logreader-lnav:
	curl -sLo /tmp/lnav.zip https://github.com/tstack/lnav/releases/download/v0.11.1/lnav-0.11.1-x86_64-linux-musl.zip
	cd /tmp && unzip lnav.zip
	mv /tmp/lnav-0.11.1/lnav ~/dotfiles/bin
	lnav -i extra

install-console-loki-logcli:
	curl -sLo /tmp/logcli.zip https://github.com/grafana/loki/releases/download/v2.2.1/logcli-linux-amd64.zip
	cd /tmp && unzip logcli.zip
	mv /tmp/logcli-linux-amd64 ~/dotfiles/bin/logcli
	chmod +x ~/dotfiles/bin/logcli

install-console-loki-cortextool:
	curl -sLo /tmp/cortextool.tar.gz https://github.com/grafana/cortex-tools/releases/download/$(shell curl -s https://api.github.com/repos/grafana/cortex-tools/releases/latest | grep tag_name | cut -d '"' -f 4)/cortextool_$(shell curl -s https://api.github.com/repos/grafana/cortex-tools/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c 2- )_linux_amd64.tar.gz
	tar -xvzf /tmp/cortextool.tar.gz -C /tmp
	cp /tmp/cortextool ~/dotfiles/bin/cortextool
	chmod +x ~/dotfiles/bin/cortextool

install-console-loki-benchtool:
	curl -sLo ~/dotfiles/bin/benchtool https://github.com/grafana/cortex-tools/releases/download/$(shell curl -s https://api.github.com/repos/grafana/cortex-tools/releases/latest | grep tag_name | cut -d '"' -f 4)/benchtool_$(shell curl -s https://api.github.com/repos/grafana/cortex-tools/releases/latest | grep tag_name | cut -d '"' -f 4 | cut -c 2- )_linux_x86_64
	chmod +x ~/dotfiles/bin/benchtool


# run github actions locally
# # Run a specific job:
# act -j test
install-github-actions-act:
	curl -sLo /tmp/act.tar.gz https://github.com/nektos/act/releases/download/$(shell curl -s https://api.github.com/repos/nektos/act/releases/latest | grep tag_name | cut -d '"' -f 4)/act_Linux_x86_64.tar.gz
	tar -xvzf /tmp/act.tar.gz -C /tmp
	cp /tmp/act ~/dotfiles/bin/act
	chmod +x ~/dotfiles/bin/act

global-console-logreader-lnav:
	sudo cp $(PWD)/bin/lnav /usr/local/bin

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
	curl -sLo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/0.24.4/fzf-0.24.4-linux_amd64.tar.gz
	tar -xvzf /tmp/fzf.tar.gz -C /tmp
	cp /tmp/fzf ~/dotfiles/bin
	echo "Consider running make zsh-fzf to install zsh shell integration"

# WTF is a personal information dashboard for your terminal, developed for those who spend most of their day in the command line.
install-console-wtfutil:
	curl -sLo /tmp/wtf.tar.gz https://github.com/wtfutil/wtf/releases/download/v0.42.0/wtf_0.42.0_linux_amd64.tar.gz
	tar -xvzf /tmp/wtf.tar.gz -C /tmp
	cp /tmp/wtf_0.42.0_linux_amd64/wtfutil ~/dotfiles/bin/wtfutil
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
	curl -sLo /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
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

install-console-gdu:
	curl -sLo /tmp/gdu.tar.gz https://github.com/dundee/gdu/releases/download/v4.11.0/gdu_linux_amd64.tgz
	tar -xvzf /tmp/gdu.tar.gz -C /tmp
	mv /tmp/gdu_linux_amd64 ~/dotfiles/bin/gdu
	chmod +x ~/dotfiles/bin/gdu

install-console-procs:
	curl -sLo /tmp/procs.zip https://github.com/dalance/procs/releases/download/v0.11.4/procs-v0.11.4-x86_64-lnx.zip
	cd /tmp && unzip procs.zip
	mv /tmp/procs ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/procs

# jql for yml
install-console-yq:
	curl -sLo ~/dotfiles/bin/yq https://github.com/mikefarah/yq/releases/download/v4.6.1/yq_linux_amd64
	chmod +x ~/dotfiles/bin/yq

install-console-jiq:
	curl -sLo ~/dotfiles/bin/jiq https://github.com/fiatjaf/jiq/releases/download/0.7.1/jiq_linux_amd64
	chmod +x ~/dotfiles/bin/jiq

install-console-jq:
	curl -sLo ~/dotfiles/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
	chmod +x ~/dotfiles/bin/jq

install-ngrok:
	curl -sLo ~/dotfiles/bin/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	cd ~/dotfiles/bin/ && unzip ngrok.zip
	rm ~/dotfiles/bin/ngrok.zip

install-promtool:
	curl -sLo /tmp/prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v2.23.0/prometheus-2.23.0.linux-amd64.tar.gz
	cd /tmp && tar -xzf prometheus.tar.gz --wildcards --no-anchored '*promtool*'
	cp /tmp/prometheus-2.23.0.linux-amd64/promtool ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/promtool

install-console-shellharden:
	curl -sLo ~/dotfiles/bin/shellharden https://github.com/anordal/shellharden/releases/download/v4.1.1/shellharden-4.1.1-x86_64-linux-gnu
	chmod +x ~/dotfiles/bin/shellharden

install-console-exa:
	mkdir -p /tmp/exa
	curl -sLo /tmp/exa/exa.zip https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip
	cd /tmp/exa/ && unzip exa.zip
	mv /tmp/exa/bin/exa ~/dotfiles/bin
	rm -rf /tmp/exa

install-console-httpie-xh:
	curl -sLo /tmp/xh.tar.gz https://github.com/ducaale/xh/releases/download/v0.10.0/xh-v0.10.0-x86_64-unknown-linux-musl.tar.gz
	tar -xvzf /tmp/xh.tar.gz -C /tmp
	mv /tmp/xh-v0.10.0-x86_64-unknown-linux-musl/xh ~/dotfiles/bin
	chmod +x ~/dotfiles/bin
	ln -s ~/dotfiles/bin/xh ~/dotfiles/bin/xhs
	cp /tmp/xh-v0.10.0-x86_64-unknown-linux-musl/completions/* ~/dotfiles/completions


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
	curl -sLo ~/dotfiles/bin/direnv https://github.com/direnv/direnv/releases/download/v2.24.0/direnv.linux-amd64
	chmod +x ~/dotfiles/bin/direnv

# https://github.com/VirtusLab/git-machete
# https://plugins.jetbrains.com/plugin/14221-git-machete
install-git-machete:
	curl -L https://raw.githubusercontent.com/VirtusLab/git-machete/master/completion/git-machete.completion.zsh -o ~/dotfiles/completions/git-machete.completion.zsh
	sudo snap install --classic git-machete

install-git-changelog:
	curl -sLo ~/dotfiles/bin/git-chglog https://github.com/git-chglog/git-chglog/releases/download/0.9.1/git-chglog_linux_amd64
	chmod +x ~/dotfiles/bin/git-chglog

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

install-docker-credential-ecr-login:
	curl -sLo ~/dotfiles/bin/docker-credential-ecr-login https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/0.4.0/linux-amd64/docker-credential-ecr-login
	chmod +x ~/dotfiles/bin/docker-credential-ecr-login

install-docker-credential-pass:
	curl -sLo /tmp/docker-credential-pass.tar.gz https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz
	tar -xvzf /tmp/docker-credential-pass.tar.gz -C /tmp
	mv /tmp/docker-credential-pass ~/dotfiles/bin/
	chmod +x ~/dotfiles/bin/docker-credential-pass

# docker console manager
install-docker-dry:
	curl -sLo ~/dotfiles/bin/dry https://github.com/moncho/dry/releases/download/v0.9-beta.4/dry-linux-amd64
	chmod +x ~/dotfiles/bin/dry

# A CLI tool and go library for generating a Software Bill of Materials (SBOM) from container images and filesystems.
# Exceptional for vulnerability detection when used with a scanner tool like Grype.
#https://github.com/anchore/syft
install-docker-scanner-syft:
	curl -sLo /tmp/syft.tar.gz https://github.com/anchore/syft/releases/download/v0.19.1/syft_0.19.1_linux_amd64.tar.gz
	tar -xvzf /tmp/syft.tar.gz -C /tmp
	mv /tmp/syft ~/dotfiles/bin/
	chmod +x ~/dotfiles/bin/syft

install-docker-scanner-grype:
	curl -sLo /tmp/grype.tar.gz https://github.com/anchore/grype/releases/download/v0.15.0/grype_0.15.0_linux_amd64.tar.gz
	tar -xvzf /tmp/grype.tar.gz -C /tmp
	mv /tmp/grype ~/dotfiles/bin/
	chmod +x ~/dotfiles/bin/grype

#
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

install-docker-lint:
	curl -sLo ~/dotfiles/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.19.0/hadolint-Linux-x86_64
	ln -s ~/dotfiles/bin/hadolint  ~/dotfiles/bin/docker-lint

install-docker-ctop:
	curl -sLo ~/dotfiles/bin/ctop https://github.com/bcicen/ctop/releases/download/v0.7.5/ctop-0.7.5-linux-amd64
	chmod +x ~/dotfiles/bin/ctop
# /DOCKER TOOLS


# KUBERNETES
# includes upgrade, disables k3s by default as you don't need it up on dev notebook
install-k3s-local:
	curl -sfL https://get.k3s.io | sh -
	sudo systemctl disable k3s
# https://github.com/alexellis/k3sup/
install-k3s-up:
	curl -sLo ~/dotfiles/bin/k3sup https://github.com/alexellis/k3sup/releases/download/0.10.2/k3sup
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
	curl -sLo /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
	rm -rf /tmp/helm

install-k8s-istio:
	mkdir -p /tmp/istio
	curl -sLo /tmp/istio/istio.tar.gz "https://github.com/istio/istio/releases/download/1.9.1/istioctl-1.9.1-linux-amd64.tar.gz"
	cd /tmp/istio && tar -xzf istio.tar.gz && mv /tmp/istio/istioctl ~/dotfiles/bin/istioctl
	rm -rf /tmp/istio

install-k8s-istio-183:
	mkdir -p /tmp/istio
	curl -sLo /tmp/istio/istio.tar.gz "https://github.com/istio/istio/releases/download/1.8.3/istioctl-1.8.3-linux-amd64.tar.gz"
	cd /tmp/istio && tar -xzf istio.tar.gz && mv /tmp/istio/istioctl ~/dotfiles/bin/istioctl183
	rm -rf /tmp/istio


https://github.com/istio/istio/releases/download/1.9.1/istioctl-1.9.1-linux-amd64.tar.gz

install-k8s-helm-plugin-s3:
	helm plugin install https://github.com/hypnoglow/helm-s3.git

install-k8-helm-plugin-starter:
	helm plugin install https://github.com/salesforce/helm-starter.git

install-k8s-helm-chartmuseum:
	curl -sLo ~/dotfiles/bin/chartmuseum https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
	chmod +x ~/dotfiles/bin/chartmuseum

# latest released helm
install-k8s-helm-latest:
	mkdir -p /tmp/helm
	curl -sLo /tmp/helm/helm.tar.gz "https://get.helm.sh/helm-$(shell curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64.tar.gz"
	cd /tmp/helm && tar -xzf helm.tar.gz && mv /tmp/helm/linux-amd64/helm ~/dotfiles/bin/helm
	rm -rf /tmp/helm

install-k8s-deepmind-kapitan:
#	pip3 install --user --upgrade git+https://github.com/deepmind/kapitan.git  --process-dependency-links
	curl -sLo ~/dotfiles/bin/kapitan https://github.com/deepmind/kapitan/releases/download/v0.29.4/kapitan-linux-amd64
	chmod +x ~/dotfiles/bin/kapitan
	echo "You can alternatively install with pip, if you have python 3.6"
	echo "pip3 install --user --upgrade kapitan"

install-k8s-heptio-authenticator-aws:
	curl -sLo ~/dotfiles/bin/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
	curl -sLo ~/dotfiles/bin/heptio-authenticator-aws.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws.md5
	chmod +x ~/dotfiles/bin/heptio-authenticator-aws

install-k8s-aws-iam-authenticator:
	curl -sLo ~/dotfiles/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.8/2020-09-18/bin/linux/amd64/aws-iam-authenticator
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

install-k8s-kubectl-color:
	mkdir -p /tmp/kubecolor
	curl -sLo /tmp/kubecolor/kubecolor.tar.gz https://github.com/dty1er/kubecolor/releases/download/v0.0.9/kubecolor_0.0.9_Linux_x86_64.tar.gz
	cd /tmp/kubecolor && tar -xzf kubecolor.tar.gz && mv /tmp/kubecolor/kubecolor ~/dotfiles/bin/
	ln -s ~/dotfiles/bin/kubecolor  ~/dotfiles/bin/kc

install-k8s-kubectl-cert_manager:
	mkdir -p /tmp/kubecertmanager
	curl -sLo /tmp/kubecertmanager/kubectl-cert-manager.tar.gz https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/kubectl-cert_manager-linux-amd64.tar.gz
	cd /tmp/kubecertmanager && tar xzf kubectl-cert-manager.tar.gz && mv /tmp/kubecertmanager/kubectl-cert_manager ~/dotfiles/bin/
	curl -sLo /tmp/kubecertmanager/cmctl.tar.gz https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cmctl-linux-amd64.tar.gz
	cd /tmp/kubecertmanager && tar xzf cmctl.tar.gz && mv /tmp/kubecertmanager/cmctl ~/dotfiles/bin/

# terminal UI to interact with your Kubernetes
install-k8s-k9s:
	mkdir -p /tmp/k9s
	curl -sLo /tmp/k9s/k9s.tar.gz https://github.com/derailed/k9s/releases/download/$(shell curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)/k9s_Linux_x86_64.tar.gz
	cd /tmp/k9s && tar -xzf k9s.tar.gz && mv /tmp/k9s/k9s ~/dotfiles/bin/
	chmod +x ~/dotfiles/bin/k9s
	rm -rf /tmp/k9s

# kubie is an alternative to kubectx, kubens and the k on prompt modification script. It offers context switching, namespace switching and prompt modification
# in a way that makes each shell independent from others. It also has support for split configuration files, meaning it can load Kubernetes contexts from
# multiple files. You can configure the paths where kubie will look for context
install-k8s-kubie:
	curl -sLo ~/dotfiles/bin/kubie https://github.com/sbstp/kubie/releases/download/v0.9.1/kubie-linux-amd64
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
	curl -sLo /tmp/octant.deb https://github.com/vmware-tanzu/octant/releases/download/v0.25.0/octant_0.25.0_Linux-64bit.deb
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
	curl -Lo ~/dotfiles/bin/kubebox https://github.com/astefanutti/kubebox/releases/download/v0.10.0/kubebox-linux
	chmod +x ~/dotfiles/bin/kubebox
	echo Do not forget to install cadvisor, for example kubectl apply -f https://raw.github.com/astefanutti/kubebox/master/cadvisor.yaml

# https://github.com/ksync/ksync/
# It transparently updates containers running on the cluster from your local checkout.
# docker run -v /foo:/bar =>  ksync create --pod=my-pod local_directory remote_directory
# ksync watch
install-k8s-ksync:
	curl -Lo ~/dotfiles/bin/ksync https://github.com/ksync/ksync/releases/download/0.4.5/ksync_linux_amd64
	chmod +x ~/dotfiles/bin/ksync

install-k8s-kubectl-krew:
	~/dotfiles/bin/get_kubectl_krew.sh

install-k8s-critctl:
	curl --output /tmp/crictl.tar.gz -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$(shell curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest | grep tag_name | cut -d '"' -f 4)/crictl-$(shell curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64.tar.gz
	tar zxvf /tmp/crictl.tar.gz -C ~/dotfiles/bin/

install-k8s-kubectl-krew-plugins:
	# https://github.com/rajatjindal/kubectl-whoami
	kubectl krew install whoami
	# https://github.com/alecjacobs5401/kubectl-sick-pods
	kubectl krew install sick-pods
	# https://github.com/Ladicle/kubectl-rolesum
	kubectl krew install rolesum
	# https://github.com/Trendyol/kubectl-view-webhook#kubectl-view-webhook
	kubectl krew install view-webhook
	# installed separately via Makefile install-k8s-popeye
#	kubectl krew install popeye
	# installed separately via Makefile install-k8s-rakkess
#	kubectl krew install access-matrix
	# https://github.com/jordanwilson230/kubectl-plugins/blob/krew/kubectl-exec-as
	kubectl krew install exec-as

install-k8s-kubescape:
	curl -Lo ~/dotfiles/bin/kubescape https://github.com/armosec/kubescape/releases/download/betav1.0.43/kubescape-ubuntu-latest
	chmod +x ~/dotfiles/bin/kubescape
	echo try
	echo kubescape scan framework nsa --exclude-namespaces kube-system,kube-public

install-k8s-kustomize:
	curl -sLo /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.4.0/kustomize_v4.4.0_linux_amd64.tar.gz
	tar -xvzf /tmp/kustomize.tar.gz -C /tmp
	mv /tmp/kustomize ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/kustomize

install-k8s-telepresence:
	sudo apt install sshfs conntrack torsocks
	curl -sLo ~/dotfiles/bin/telepresence  https://app.getambassador.io/download/tel2/linux/amd64/latest/telepresence
	chmod a+x ~/dotfiles/bin/telepresence

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
	helm repo add loki https://grafana.github.io/loki/charts
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stakater https://stakater.github.io/stakater-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add sentry https://sentry-kubernetes.github.io/charts

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
	rm -rf /tmp/dash-to-dock ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
	mkdir -p /tmp/dash-to-dock
	curl -sLo /tmp/dash-to-dock/dashtodock.zip https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v68.shell-extension.zip
	mkdir -p ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
	unzip /tmp/dash-to-dock/dashtodock.zip -d ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
	echo "Shell reload is required Alt+F2 r Enter"
#	git clone https://github.com/micheleg/dash-to-dock.git /tmp/dash-to-dock
#	cd /tmp/dash-to-dock && git checkout origin/tmp/gnome-3.36 && make && make install

gnome-unite-shell:
	rm -rf /tmp/gnome-unite-shell
	git clone https://github.com/hardpixel/unite-shell.git /tmp/gnome-unite-shell
	mv /tmp/gnome-unite-shell/unite@hardpixel.eu ~/.local/share/gnome-shell/extensions/unite@hardpixel.eu

# apt-cache show gnome-shell | grep Version
gnome-status-area-horizontal-spacing:
	rm -rf /tmp/status-area-horizontal-spacing-gnome-shell-extension
	git clone git@gitlab.com:p91paul/status-area-horizontal-spacing-gnome-shell-extension.git /tmp/status-area-horizontal-spacing-gnome-shell-extension
	cd /tmp/status-area-horizontal-spacing-gnome-shell-extension && git checkout gnome3.2
	rm -rf ~/.local/share/gnome-shell/extensions/status-area-horizontal-spacing@mathematical.coffee.gmail.com
	mv /tmp/status-area-horizontal-spacing-gnome-shell-extension/status-area-horizontal-spacing@mathematical.coffee.gmail.com   ~/.local/share/gnome-shell/extensions/status-area-horizontal-spacing@mathematical.coffee.gmail.com

gnome-shell-system-monitor:
	sudo apt install gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0 gnome-system-monitor
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

gnome-shell-put-windows:
	rm -rf /tmp/gnome-shell-extensions-negesti
	git clone git@github.com:negesti/gnome-shell-extensions-negesti.git /tmp/gnome-shell-extensions-negesti
	mv /tmp/gnome-shell-extensions-negesti  ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org
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

# +plugins=( ... git-extra-commands )
# https://github.com/unixorn/git-extra-commands
zsh-git-extra-commands:
	rm -rf ~/.oh-my-zsh/custom/plugins/git-extra-command || true
	git clone https://github.com/unixorn/git-extra-commands.git ~/.oh-my-zsh/custom/plugins/git-extra-command

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
	curl -sLo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)/terraform-docs-$(shell curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)-linux-amd64.tar.gz
	tar -xvzf /tmp/terraform-docs.tar.gz -C /tmp
	cp /tmp/terraform-docs ~/dotfiles/bin
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
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform012 && chmod +x terraform012 && rm terraform.zip && mv terraform012 ~/dotfiles/bin/

install-hashicorp-terraform013:
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform013 && chmod +x terraform013 && rm terraform.zip && mv terraform013 ~/dotfiles/bin/

install-hashicorp-terraform014:
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform014 && chmod +x terraform014 && rm terraform.zip && mv terraform013 ~/dotfiles/bin/

install-hashicorp-terraform100:
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && mv terraform terraform100 && chmod +x terraform100 && rm terraform.zip && mv terraform100 ~/dotfiles/bin/

install-hashicorp-terraform:
	curl -sLo ~/tmp/terraform.zip "https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.11_linux_amd64.zip"
	cd ~/tmp/ && unzip terraform.zip && chmod +x terraform && rm terraform.zip && mv terraform ~/dotfiles/bin/

install-hashicorp-packer:
	curl -sLo ~/dotfiles/bin/packer.zip "https://releases.hashicorp.com/packer/1.8.3/packer_1.8.3_linux_amd64.zip"
	cd ~/dotfiles/bin/ && unzip packer.zip && chmod +x packer && rm packer.zip


#/HASHICORP

# GO

install-go-gimme:
	curl -sL -o ~/dotfiles/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x ~/dotfiles/bin/gimme

install-go-global:
	curl -sLo /tmp/go1.19.3.tar.gz  https://go.dev/dl/go1.19.3.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf /tmp/go1.19.3.tar.gz

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

# utility to speedup working with aws nodes via ssm
install-aws-ssm:
	curl -sLo /tmp/ssm.tar.gz https://github.com/disneystreaming/ssm-helpers/releases/download/v1.0.0/ssm-helpers_1.0.0_Linux_x86_64.tar.gz
	tar -xvzf /tmp/ssm.tar.gz -C /tmp
	mv /tmp/ssm ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/ssm

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
install-aws-cli:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
	cd /tmp && unzip awscliv2.zip
	cd /tmp && sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

install-ovh-nova:
	sudo pip install python-openstackclient

# https://console.aws.amazon.com/cloudformation/designer
# https://github.com/awslabs/aws-cfn-template-flip
install-aws-cfn-template-flip:
	sudo pip3 install cfn-flip

# https://github.com/salesforce/cloudsplaining
# eval "$(_CLOUDSPLAINING_COMPLETE=source_zsh cloudsplaining)"
install-aws-salesforce-cloudplaining:
	pip3 install --user cloudsplaining

# https://github.com/salesforce/policy_sentry
# eval "$(_POLICY_SENTRY_COMPLETE=source_zsh policy_sentry)"
install-aws-salesforce-policy-sentry:
	pip3 install --user policy_sentry
	echo "consider local initialization with 'policy_sentry initialize'"

install-digitalocean-cli:
	curl -sLo /tmp/doctl.tar.gz https://github.com/digitalocean/doctl/releases/download/v1.64.0/doctl-1.64.0-linux-amd64.tar.gz
	tar -xvzf /tmp/doctl.tar.gz -C ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/doctl
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

install-screenshot-tool:
	curl -sLo /tmp/ksnip.deb https://github.com/ksnip/ksnip/releases/download/v1.8.0/ksnip-1.8.0.deb
	sudo apt install /tmp/ksnip.deb

# /LAPTOP


# AWS

#https://aws.amazon.com/serverless/sam/
install-aws-sam-cli:
	mkdir -p /tmp/aws-sam-cli
	curl -sLo /tmp/aws-sam-cli/aws-sam-cli.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
	mkdir -p ~/apps/aws-sam-cli
	unzip /tmp/aws-sam-cli/aws-sam-cli.zip -d ~/apps/aws-sam-cli/
	cd ~/apps/aws-sam-cli/ && sudo ./install

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

sec-expoit-suggest:
	curl -sLo ~/dotfiles/bin/linux-exploit-suggester.sh https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh
	chmod +x ~/dotfiles/bin/linux-exploit-suggester.sh

# /SECURITY


# DOCUMENTATION

# https://www.mkdocs.org/
install-mkdocs:
	pip install mkdocs

# Small markdown to confluence
install-confluence-mark:
	curl -sLo /tmp/confluencemark.tar.gz https://github.com/kovetskiy/mark/releases/download/4.1/mark_4.1_Linux_x86_64.tar.gz
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
	@echo dbml2sql schema.dbml
	@echo dbml2sql schema.dbml --mysql
	@echo "dbml2sql <path-to-dbml-file> [--mysql|--postgres] [-o|--out-file <output-filepath>]"
	@echo sql2dbml dump.sql --postgres
	@echo sql2dbml --mysql dump.sql -o mydatabase.dbml
	@echo "sql2dbml <path-to-sql-file> [--mysql|--postgres] [-o|--out-file <output-filepath>]"

# Backup tools
install-borg:
	curl -sLo ~/dotfiles/bin/borg https://github.com/borgbackup/borg/releases/download/1.1.17/borg-linux64
	chmod +x ~/dotfiles/bin/borg
	@echo "To link globally,"
	@echo sudo ln -s $(HOME)/dotfiles/bin/borg  /usr/local/bin/borg
	# https://github.com/dschep/ntfy
	# pip3 install --upgrade ntfy[pid,emoji,xmpp,telegram,instapush,slack,rocketchat]
	# https://github.com/witten/borgmatic
	# pip3 install --upgrade borgmatic

# https://vorta.borgbase.com/
install-borg-ui-vorta:
	sudo pip3 install vorta

install-borg-borgmatic:
	pip3 install --upgrade ntfy[pid,emoji,xmpp,telegram,instapush,slack,rocketchat]

# security

install-rengine:
	mkdir -p ~/apps
	git clone git@github.com:yogeshojha/rengine.git ~/apps/rengine
	cd ~/apps/rengine && make build

# https://ostechnix.com/debian-goodies-a-set-of-useful-utilities-for-debian-and-ubuntu-users/
# https://blog.sleeplessbeastie.eu/2015/03/02/how-to-verify-installed-packages/
# https://www.tecmint.com/install-rootkit-hunter-scan-for-rootkits-backdoors-in-linux/
install-base-security:
	sudo apt-get install lynis debian-goodies needrestart debsums debsecan rkhunter

# /security

# swagger

install-misc-swagen:
	rm -rf /tmp/swagen || true
	mkdir -p /tmp/swagen
	git clone git@github.com:minitauros/swagen.git /tmp/swagen
	cd /tmp/swagen && go build -o ~/dotfiles/bin/swagen main.go

install-misc-albert-source:
	rm -rf $(HOME)/albert
	cd $(HOME) && git clone --recursive https://github.com/albertlauncher/albert.git
	cd $(HOME)/albert
	mkdir -p albert-build
	cd albert-build
	cmake ../albert -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
	make
	echo "Consider installing plugins from  https://github.com/bergercookie/awesome-albert-plugins"

install-misc-albert-plugins:
	git clone https://github.com/bergercookie/awesome-albert-plugins.git ~/.local/share/albert/org.albert.extension.python/modules

# https://software.opensuse.org/download.html?project=home:manuelschneid3r&package=albert
install-misc-albert-deb:
	echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
	curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_18.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
	sudo apt update
	sudo apt install albert
	echo "Consider installing plugins from  https://github.com/bergercookie/awesome-albert-plugins"

install-misc-youtube-dl:
	curl -sLo ~/dotfiles/bin/youtube-dl https://github.com/ytdl-org/youtube-dl/releases/download/2021.01.16/youtube-dl
	chmod +x ~/dotfiles/bin/youtube-dl
	echo youtube-dl -i ..playlist..

install-misc-cadvisor:
	curl -sLo ~/dotfiles/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.38.7/cadvisor
	chmod +x ~/dotfiles/bin/cadvisor


# replace system python with custom
#add-apt-repository ppa:deadsnakes/ppa
#apt install python3.8
# update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1


# https://github.com/CoatiSoftware/Sourcetrail
install-sourcetrail:
	curl -sLo /tmp/sourcetrail.tar.gz https://github.com/CoatiSoftware/Sourcetrail/releases/download/2021.1.30/Sourcetrail_2021_1_30_Linux_64bit.tar.gz
	tar -xvzf /tmp/sourcetrail.tar.gz -C /tmp
	mv /tmp/Sourcetrail $(HOME)/apps
	ln -f -s $(HOME)/apps/Sourcetrail/Sourcetrail.sh $(HOME)/dotfiles/bin/sourcetrail

# DATABASE helpers

#https://github.com/dbcli/pgcli
install-db-cli-postgres:
	pip3 install --user -U pgcli
	echo "Usage: pgcli DBURI"

# https://github.com/hatarist/clickhouse-cli
install-db-cli-clickhouse:
	pip3 install --user clickhouse-cli

install-db-cli-clickhouse-native:
	sudo apt-get install apt-transport-https ca-certificates dirmngr
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4

	echo "deb https://repo.clickhouse.tech/deb/stable/ main/" | sudo tee /etc/apt/sources.list.d/clickhouse.list
	sudo apt-get update
	sudo apt-get install -y clickhouse-client
	echo "Native client:"
	which clickhouse-client
	echo "To install server:  clickhouse-server followed by  sudo service clickhouse-server start"

testssl:
	git clone --depth 1 git@github.com:drwetter/testssl.sh.git $(HOME)/dotfiles/bin/testssl

# for mqtt consider http://mqtt-explorer.com/
install-queue-plumber:
	curl -sLo ~/dotfiles/bin/plumber https://github.com/batchcorp/plumber/releases/download/v1.0.4/plumber-linux
	chmod +x ~/dotfiles/bin/plumber

install-bitwarden-cli:
	curl -sLo /tmp/bw.zip "https://vault.bitwarden.com/download/?app=cli&platform=linux"
	unzip /tmp/bw.zip -d ~/dotfiles/bin
	chmod +x ~/dotfiles/bin/bw

# http://www.ddcutil.com/
# ddcutil capabilities | grep Brightness
# get bright
# sudo ddcutil getvcp 10
# set bright
# sudo ddcutil setvcp 10 70
install-ddcutil:
	sudo apt install ddcutil

install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# https://github.com/johannesjo/linux-window-session-manager
install-lwsm:
	npm install -g linux-window-session-manager
#

update-open-ssl:
	mkdir /tmp/openssl
	cd /tmp/openssl && \
	wget https://www.openssl.org/source/openssl-1.1.1q.tar.gz && \
	wget https://www.openssl.org/source/openssl-1.1.1q.tar.gz.sha256 && \
	echo "$(cat openssl-1.1.1q.tar.gz.sha256) openssl-1.1.1q.tar.gz" | sha256sum --check && \
	tar -zxf openssl-1.1.1q.tar.gz && \
	cd openssl-1.1.1q && \
	./config && \
	make && \
	make test && \
	sudo make install

# https://github.com/netblue30/firejail/releases/download/0.9.64.2/firejail_0.9.64.2_1_amd64.deb
# https://github.com/iann0036/iamlive

# https://gitlab.com/nowayout/prochunter
# https://github.com/fatedier/frp

# https://github.com/grafana/grizzly
# https://github.com/cznewt/jsonnet-utils
# python -m pip install git+https://github.com/cznewt/jsonnet-utils.git

# https://github.com/satyanash/promql-jsonnet

#https://github.com/gruntwork-io/git-xargs/releases

#https://github.com/DominicBreuker/pspy

#https://github.com/go-acme/lego

# https://github.com/quarkslab/kdigger


# Logi

# sudo add-apt-repository ppa:solaar-unifying/stable
# sudo apt update
#  sudo apt install solaar

# https://github.com/norwoodj/helm-docs

# https://blog.jetbrains.com/idea/2022/12/http-client-cli-run-requests-and-tests-on-ci/
