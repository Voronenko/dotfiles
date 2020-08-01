#!/bin/bash

# curl -sSL http://bit.ly/slavkodotfiles > bootstrap.sh && chmod +x bootstrap.sh
# ./bootstrap.sh  <optional: simple | full | docker>

set -e

SUDO=${BECOME_METHOD:-sudo}

if [ "$1" == "docker" ]; then
SUDO="${BECOME_METHOD:-}"
EXTRA_PACKAGES="sudo less"
fi

PREFERRED_SHELL=${2:-zsh}
PREFFERED_PYTHON=python3
PREFFERED_PIP=pip3

if [ "$(id -u)" == "0" ] && [ "$1" == "full" ]; then
echo "Installation must NOT be done under sudo"
echo "use your regular user account"
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
    echo "No supported package manager"
    exit 1
fi

$SUDO $pkgmanager -y install git curl nano $EXTRA_PACKAGES

if [ "$1" == "full" ]; then

  SUDOERUSER="$(whoami)"
  SUDOERFILE="/etc/sudoers.d/$SUDOERUSER"

  $SUDO bash -c "touch $SUDOERFILE"
  $SUDO bash -c "echo $SUDOERUSER ALL=\(ALL\) NOPASSWD: ALL > $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /usr/bin/truecrypt >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /bin/systemctl >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD: /etc/init.d/nginx, /etc/init.d/mysql, /etc/init.d/mongod, /etc/init.d/redis, /etc/init.d/php-fpm >> $SUDOERFILE"
  $SUDO bash -c "echo # $SUDOERUSER ALL=\(ALL\) NOPASSWD:SETENV: /usr/bin/docker, /usr/sbin/docker-gc >> $SUDOERFILE"

  echo "===================================================================="
  echo "current user was added to SUDOERS w/o password"
  echo "don't  forget to remove settings after initial box configuration"
  echo "by removing file $SUDOERFILE"
  echo "===================================================================="


  if [ -e /usr/bin/yum ]
  then
      $SUDO yum install -y epel-release
      $SUDO yum install -y $PREFFERED_PYTHON-cffi
      $SUDO yum groupinstall -y "Development Tools"
      $SUDO yum install -y $PREFFERED_PYTHON-devel
      $SUDO yum install -y openssl-devel
      $SUDO yum install -y nano
  elif [ -e /usr/bin/apt ]
  then
      $SUDO apt-get -y install -y software-properties-common $PREFFERED_PYTHON-dev wget apt-transport-https libffi-dev libssl-dev
  fi

  $SUDO $pkgmanager install -y $PREFFERED_PYTHON-pip
  $SUDO $PREFFERED_PIP install -U $PREFFERED_PIP
  $SUDO $PREFFERED_PIP install ansible

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
  ./init_simple.sh $PREFERRED_SHELL
else
  ./init.sh
fi
