#!/usr/bin/env bash
set -e

function link {
    # param: src 
    #    src file or folder inside this repo
    # param: dst
    #    dst location inside the $HOME folder
    rm -rf ${HOME}/$2
    ln -s ${HOME}/.dotfiles/$1 ${HOME}/$2
}

echo "--- Setting symlinks to the dotfiles."
link tmux/tmux.conf .tmux.conf

echo "--- Installing packages."
if [[ `uname -s` == "Darwin" ]]; then
    ./macos/install_packages.sh
elif [[ `uname -s` == "Linux" ]]; then
    ./linux/install_packages.sh
fi

./sh/install.sh
./python/install.sh
./nvim/install_nvim.sh
./skuld/install.sh
./fonts/install.sh

echo "--- Done."
