#!/bin/bash

echo "Ensure dependencies  sudo apt-get install libevent-dev libncurses-dev pkg-config "

mkdir -p /tmp/tmux29a
cd /tmp/tmux29a
echo "downloading and installing tmux"
curl -LOk https://github.com/tmux/tmux/releases/download/2.9a/tmux-2.9a.tar.gz
tar xf tmux-2.9a.tar.gz
cd tmux-2.9a
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
sudo make install
cd ..
echo "tmux version"
tmux -V
rm -rf tmux-2.9a
rm tmux-2.9a.tar.gz
