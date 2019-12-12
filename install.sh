#!/bin/bash

function backup_and_link {
    # if [[ -f ${HOME}/.$1 ]]; then
    #     if [[ -f ${HOME}/.$1_bu ]]; then
    #         echo "Skipping backup of $1, already exists."
    #     elif
    #         mv ${HOME}/.$1 ${HOME}/.$1_bu
    #     fi
    # fi
    rm -rf ${HOME}/.$1
    ln -s ${HOME}/.dotfiles/$2/$1 ${HOME}/.$1 
}

echo "--- Setting symlinks to the dotfiles."
backup_and_link vimrc vim
backup_and_link tmux.conf tmux

if [[ `uname -s` == "Darwin" ]]; then
    backup_and_link bash_profile macos
    backup_and_link profile macos
    source ${HOME}/.bash_profile
    ./macos/install_packages.sh
    # ./python/install_python_macos.sh
elif [[ `uname -s` == "Linux" ]]; then
    backup_and_link bashrc linux
    backup_and_link profile linux
    source ${HOME}/.bashrc
    ./linux/install_packages.sh
    ./python/install_python_linux.sh
    if [[ `uname -m` == "aarch64" ]]; then
        sudo cp skuld/skuld_linux_amd64 /usr/local/bin/skuld
    elif [[ `uname -m` == "x86_64" ]]; then
        sudo cp skuld/skuld_linux_aarch64 /usr/local/bin/skuld
    fi
fi

./vim/install_vim.sh
./nvim/install_nvim.sh
./sh/install.sh
