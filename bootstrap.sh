#!/bin/bash

# curl -sSL http://bit.ly/slavkodotfiles > bootstrap.sh && chmod +x bootstrap.sh
# ./bootstrap.sh  <optional: simple | full | docker>

# curl -sSL http://bit.ly/slavkodotfiles | bash -s
set -e

readonly C_NOC="\\033[0m"    # No colour
readonly C_RED="\\033[0;31m" # Red
readonly C_GRN="\\033[0;32m" # Green
readonly C_BLU="\\033[0;34m" # Blue
readonly C_PUR="\\033[0;35m" # Purple
readonly C_CYA="\\033[0;36m" # Cyan
readonly C_WHI="\\033[0;37m" # White
### Helper functions
print_red () { local i; for i in "$@"; do echo -e "${C_RED}${i}${C_NOC}"; done }
print_grn () { local i; for i in "$@"; do echo -e "${C_GRN}${i}${C_NOC}"; done }
print_blu () { local i; for i in "$@"; do echo -e "${C_BLU}${i}${C_NOC}"; done }
print_pur () { local i; for i in "$@"; do echo -e "${C_PUR}${i}${C_NOC}"; done }
print_cya () { local i; for i in "$@"; do echo -e "${C_CYA}${i}${C_NOC}"; done }
print_whi () { local i; for i in "$@"; do echo -e "${C_WHI}${i}${C_NOC}"; done }

SUDO=${BECOME_METHOD:-sudo}

if [ "$1" == "docker" ]; then
SUDO="${BECOME_METHOD:-}"
EXTRA_PACKAGES="sudo less"
fi

PREFERRED_SHELL=${2:-zsh}
PREFFERED_PYTHON=python3
PREFFERED_PIP=pip3

INSTALL_ANSIBLE=${3:-no}

if [ "$(id -u)" == "0" ] && [ "$1" == "full" ]; then
print_red "Installation must NOT be done under sudo"
print_red "use your regular user account"
exit 1
fi

if [ -e /usr/bin/apt ]
then
    pkgmanager=apt-get
    $SUDO apt-get update
elif [ -e /usr/bin/yum ]
then
    pkgmanager=yum
elif [ -e /usr/bin/dnf ]
then
    pkgmanager=dnf
else
    print_red "No supported package manager"
    exit 1
fi

$SUDO $pkgmanager -y install git curl nano make $EXTRA_PACKAGES

if [ "$1" == "full" ]; then

  SUDOERUSER="$(whoami)"
  SUDOERFILE="/etc/sudoers.d/$SUDOERUSER"

  $SUDO bash -c "touch $SUDOERFILE"
  $SUDO bash -c "echo $SUDOERUSER ALL=\(ALL\) NOPASSWD: ALL > $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /usr/bin/truecrypt >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /bin/systemctl >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown, /usr/bin/ddcutil, /usr/bin/ddccontrol >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /etc/init.d/nginx, /etc/init.d/mysql, /etc/init.d/mongod, /etc/init.d/redis, /etc/init.d/php-fpm >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD:SETENV: /usr/bin/docker, /usr/sbin/docker-gc >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD /usr/sbin/etherwake >> $SUDOERFILE"

  echo "===================================================================="
  echo "current user was added to SUDOERS w/o password"
  echo "don't  forget to remove settings after initial box configuration"
  echo "by removing file $SUDOERFILE"
  echo "===================================================================="


  if [ -e /usr/bin/yum ]
  then
      if [ "$INSTALL_ANSIBLE" == "yes" ] || [ "$INSTALL_ANSIBLE" == "y" ] ; then
      $SUDO yum install -y epel-release
      $SUDO yum groupinstall -y "Development Tools"
      $SUDO yum install -y ${PREFFERED_PYTHON}-devel
      $SUDO yum install -y ${PREFFERED_PYTHON}-cffi
      $SUDO yum install -y openssl-devel
      fi
      $SUDO yum install -y nano
  elif [ -e /usr/bin/dnf ]
  then
      $SUDO dnf install -y epel-release
      $SUDO dnf groupinstall -y "Development Tools"
      $SUDO dnf install -y "$PREFFERED_PYTHON"-devel
      $SUDO dnf install -y "$PREFFERED_PYTHON"-cffi
      $SUDO dnf install -y openssl-devel
  elif [ -e /usr/bin/apt ]
  then
      if [ "$INSTALL_ANSIBLE" == "yes" ] || [ "$INSTALL_ANSIBLE" == "y" ] ; then
      $SUDO apt-get install -y software-properties-common "$PREFFERED_PYTHON"-dev apt-transport-https libffi-dev libssl-dev
      fi
      $SUDO apt-get install -y wget
  fi

  if [ "$INSTALL_ANSIBLE" == "yes" ] || [ "$INSTALL_ANSIBLE" == "y" ] ; then
  $SUDO $pkgmanager install -y "$PREFFERED_PYTHON"-pip
  $SUDO $PREFFERED_PIP install -U "$PREFFERED_PIP"
  $SUDO $PREFFERED_PIP install ansible
  fi
fi

if [ "$1" != "docker" ]; then

echo "ssh-agent:"
eval "$(ssh-agent)"

fi

if [ "$1" == "simple" ] || [ "$1" == "docker" ]; then
  git clone https://github.com/Voronenko/dotfiles.git
else
  git clone https://github.com/Voronenko/dotfiles.git
  cd dotfiles && git remote set-url origin git@github.com:Voronenko/dotfiles.git && cd ~
fi


if [ "$1" == "full" ]; then
  git clone https://github.com/Voronenko/ansible-developer_recipes.git
  cd ansible-developer_recipes && git remote set-url origin git@github.com:Voronenko/ansible-developer_recipes.git && cd ~
fi

cd dotfiles

if [ "$1" == "simple" ] || [ "$1" == "docker" ] ; then
  ./init_simple.sh "$PREFERRED_SHELL"
else
  ./init.sh
  cd ~/dotfiles && make swiss-knife
  cd ~/dotfiles && make zsh-fzf zsh-kubetail
  cd ~/dotfiles && make install-console-fd install-console-fzf
  cd ~/dotfiles && make install-console-lazysuite
  print_grn "Consider: setup machine with ansible-developer_recipes"
  print_grn "Consider: setup machine dependent zshrc.local"
  print_grn "Consider: checking https://github.com/Voronenko/dotfiles/wiki"
fi
