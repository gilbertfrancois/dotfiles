#!/usr/bin/env bash

sudo apt update
sudo apt install -y build-essential autoconf autotools-dev libncursusw5-dev
sudo apt remove htop

cd /tmp
git clone -b 3.0.5 --single-branch --depth 1 https://github.com/htop-dev/htop.git
cd htop

./autogen.sh
./configure
make
sudo make install
