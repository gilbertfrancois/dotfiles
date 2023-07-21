#!/usr/bin/env bash

TMUX_VERSION=3.3a

sudo apt update
sudo apt install -y build-essential libncurses5-dev less autoconf automake pkg-config libevent-dev git bison yacc
sudo apt remove -y tmux

find /usr/local > /tmp/tmux-1.txt

pushd /tmp

git clone -b ${TMUX_VERSION} --single-branch --depth 1 https://github.com/tmux/tmux.git tmux
cd tmux
./autogen.sh
./configure --prefix=/usr/local
make -j4
sudo make install

cd ..
rm -rf tmux
popd

find /usr/local > /tmp/tmux-2.txt
diff /tmp/tmux-1.txt /tmp/tmux-2.txt > /tmp/install_tmux.log
