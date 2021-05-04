#!/usr/bin/env bash

set -e

NODE_VERSION="14.16.1"
FZF_VERSION="0.27.0"

NVIM_CONFIG_DIR=${HOME}/.config/nvim
NVIM_LIB_DIR=${NVIM_CONFIG_DIR}/lib

function reset_config_dir {
    echo "--- (Re)setting Neovim config folder."
    mkdir -p ${HOME}/.config
    if [ -d ${HOME}/.config/nvim ]; then
        rm -rf ${HOME}/.config/nvim
        mkdir -p ${HOME}/.config/nvim
        mkdir -p ${NVIM_LIB_DIR}
    fi
    ln -s ${HOME}/.dotfiles/nvim/init.vim ${HOME}/.config/nvim
    ln -s ${HOME}/.dotfiles/nvim/coc-settings.json ${HOME}/.config/nvim
}

function install_deps {
    echo "--- Installing ctags, ripgrep"
    " TODO: Install version for ARMv8
    if [[ `uname -s` == "Linux" ]]; then
        sudo apt install -y exuberant-ctags
        if [[ `uname -m` == "x86_64" ]]; then
            sudo snap install ripgrep --classic
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew install ctags the_silver_searcher fd ripgrep fzf
    fi
}

function install_neovim {
    echo "--- Installing Neovim."
    if [[ `uname -s` == "Linux" ]]; then
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt update
        sudo apt install -y neovim 
    elif [[ `uname -s` == "Darwin" ]]; then
        brew update
        brew install neovim
    else
        echo "Unsupported OS."
    fi 
}

function install_python {
    echo "--- Installing python environment for NeoVim."
    VENV_PATH="${NVIM_LIB_DIR}/python"
    rm -rf ${VENV_PATH}
    cd ${NVIM_LIB_DIR}
    python3 -m venv ${VENV_PATH}
    source ${VENV_PATH}/bin/activate
    pip install jedi rope ropevim pylint flake8 pynvim yapf isort autopep8
}

function install_node {
    INSTALL_DIR=${NVIM_LIB_DIR}
    echo "--- Installing nodejs."
    if [[ `uname -s` == "Linux" ]]; then
        NODE_OS="linux"
        NODE_EXTENSION="tar.xz"
        if [[ `uname -m` == "aarch64" ]]; then
            NODE_ARCH="arm64"
        elif [[ `uname -m` == "x86_64" ]]; then
            NODE_ARCH="x64"
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        NODE_OS="darwin"
        NODE_ARCH="x64"
        NODE_EXTENSION="tar.gz"
    fi
    cd /tmp
    rm -rf node*
    rm -rf ${NVIM_LIB_DIR}/node*
    mkdir -p ${NVIM_LIB_DIR}/node
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    echo "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}"
    # TODO: Make it work for macOS, with gzip compression
    tar -xvf node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    mv node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}
    ln -s ${NVIM_LIB_DIR}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}/node
    ${NVIM_LIB_DIR}/node/bin/npm i -g neovim
}

function install_fzf {
    echo "--- Installing FZF."
    if [[ `uname -s` == "Linux" ]]; then
        FZF_OS="linux"
        if [[ `uname -m` == "x86_64" ]]; then
            FZF_ARCH="amd64"
        elif [[ `uname -m` == "aarch64" ]]; then
            FZF_ARCH="arm64"
        fi
        cd /tmp
        wget https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fz-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.tar.gz
        tar zxvf fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.tar.gz
        sudo cp fzf /usr/local/bin
    elif [[ `uname -s` == "Darwin" ]]; then
        brew install fzf
    fi
}

reset_config_dir
install_neovim
install_deps
install_python
install_node
install_fzf

function post_install {
    echo "--- Setup and install NeoVim plugins."
    nvim +PluginInstall +qall
    nvim +UpdateRemotePlugins +qall
}
