#!/usr/bin/env bash

echo "--- Installing Neovim."
if [[ "${OSTYPE}" == "linux-gnu" ]]; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y exuberant-ctags neovim
elif [[ "${OSTYPE}" == "darwin"* ]]; then
    brew update
    brew install ctags neovim
else
    echo "Unsupported OS."
fi 

echo "--- Set up nvim config to share config file with vim."
mkdir -p ${HOME}/.config
if [ -d ${HOME}/.config/nvim ]; then
    rm -rf ${HOME}/.config/nvim
fi
ln -s ${HOME}/.dotfiles/nvim ${HOME}/.config

echo "--- Install python environment for NeoVim."
rm -rf ${HOME}/.config/nvim_python
mkdir -p ${HOME}/.config/nvim_python
cd ${HOME}/.config/nvim_python
pyenv local 3.7.5
pipenv --python 3.7.5
pipenv install jedi rope ropevim pylint flake8 pynvim yapf isort autopep8

echo "--- Install nodejs for coc completer"
NODE_VERSION="10.16.3"
if [[ `uname -s` == "Linux" ]]; then
    if [[ `uname -m` == "aarch64" ]]; then
        NODE_OS="linux"
        NODE_ARCH="arm64"
        NODE_EXTENSION="tar.xz"
    elif [[ `uname -m` == "x86_64" ]]; then
        NODE_OS="linux"
        NODE_ARCH="x64"
        NODE_EXTENSION="tar.xz"
    fi
    cd /tmp
    rm -rf node*
    sudo rm -rf /opt/node*
    sudo mkdir -p /opt
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    echo "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}"
    tar -xvf node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    sudo mv node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} /opt
    sudo ln -s /opt/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} /opt/node
elif [[ `uname -s` == "Darwin" ]]; then
    # NODE_OS="darwin"
    # NODE_ARCH="x64"
    # NODE_EXTENSION="tar.gz"
    brew update
    brew install npm node
fi


echo "--- Setup NeoVim."
# Setup NeoVim
nvim +PluginInstall +qall
nvim +UpdateRemotePlugins +qall
