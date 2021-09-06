#!/usr/bin/env bash
set -xe

function link {
    # param: src 
    #    src file or folder inside this repo
    # param: dst
    #    dst location inside the $HOME folder
    rm -rf ${HOME}/$2
    ln -s ${HOME}/.dotfiles/$1 ${HOME}/$2
}

function add_env {
    FILE_PATH="${HOME}/.${1}"
    if [ -f "${FILE_PATH}" ]; then
        if grep -q ".dotfiles/sh/profile" ${FILE_PATH}
        then
            echo "  - Shell profile already added to ${FILE_PATH}."
        else
            echo "source ${HOME}/.dotfiles/sh/profile" >> ${FILE_PATH}
            echo "  - Shell profile added to ${FILE_PATH}."
        fi
    fi
}

function install_oh_my_zsh {
    if [[ `uname -s` == "Linux" ]]; then
        sudo apt install curl zsh
    elif [[ `uname -s` == "Darwin" ]]; then
        brew install curl
    fi
    rm -rf ${HOME}/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    link sh/gilbert.zsh-theme .oh-my-zsh/themes/gilbert.zsh-theme
    chsh -s /bin/zsh
}

install_oh_my_zsh
link sh/zshrc .zshrc

echo "--- Adding stuff to the shell profile."
add_env bash_profile
add_env bashrc
add_env profile

