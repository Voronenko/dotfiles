#!/bin/bash
cd /tmp
wget https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz
tar -zxvf cmake-3.17.3.tar.gz
cd cmake-3.17.3
./bootstrap
make
sudo make install
cmake --version
echo "============================"
echo "to uninstall later"
echo "sudo make uninstall"
