#!/bin/bash

sudo apt install -y cmake libncurses5-dev libncursesw5-dev git

pushd /tmp
rm -rf nvtop
git clone https://github.com/Syllo/nvtop.git nvtop
cd nvtop

cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build

cd ..
rm -rf nvtop
popd

