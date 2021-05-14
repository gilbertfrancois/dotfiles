#!/usr/bin/env bash

cd /tmp
rm -rf neovim
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_INSTALL_PREFIX=/opt/neovim-0.5 CMAKE_BUILD_TYPE=Release
sudo make CMAKE_INSTALL_PREFIX=/opt/neovim-0.5 CMAKE_BUILD_TYPE=Release install
rm -rf neovim
