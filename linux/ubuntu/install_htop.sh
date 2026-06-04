#!/usr/bin/env bash

HTOP_VERSION=3.2.2

sudo apt update
sudo apt install -y libncursesw5-dev autotools-dev autoconf automake build-essential libncursesw5 gettext libtool libtool-bin dh-autoreconf
sudo apt remove -y htop

find /usr/local > /tmp/htop-1.txt
pushd /tmp
git clone -b ${HTOP_VERSION} --single-branch --depth 1 https://github.com/htop-dev/htop.git
cd htop

./autogen.sh
./configure --prefix=/usr/local
make
sudo make install
cd ..
rm -rf htop
popd

find /usr/local > /tmp/htop-2.txt
diff /tmp/htop-1.txt /tmp/htop-2.txt > /tmp/install_htop.log
