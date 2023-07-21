#!/usr/bin/env bash

MOSH_VERSION=mosh-1.4.0

sudo apt update
sudo apt install -y build-essential protobuf-compiler \
    libprotobuf-dev pkg-config libutempter-dev zlib1g-dev libncurses5-dev \
    libssl-dev bash-completion less autoconf automake 
sudo apt remove -y mosh

find /usr/local > /tmp/mosh-1.txt

pushd /tmp
git clone -b ${MOSH_VERSION} --single-branch --depth 1 https://github.com/mobile-shell/mosh.git mosh
cd mosh

./autogen.sh
./configure --prefix=/usr/local
make -j4
sudo make install

cd ..
rm -rf mosh
popd

find /usr/local > /tmp/mosh-2.txt
diff /tmp/mosh-1.txt /tmp/mosh-2.txt > /tmp/install_mosh.log
