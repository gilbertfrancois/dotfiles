#!/usr/bin/env bash
NODE_VERSION="14.16.1"
FZF_VERSION="0.27.0"

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

function install_deps {
    echo "--- Installing ctags, ripgrep"
    if [[ `uname -s` == "Linux" ]]; then
        sudo apt install -y exuberant-ctags
        if [[ `uname -m` == "x86_64" ]]; then
            sudo snap install ripgrep --classic
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew install ctags the_silver_searcher fd ripgrep fzf
    fi
}

function install_fzf {
    echo "--- Installing FZF"
    if [[ `uname -s` == "Linux" ]]; then
        FZF_VERSION="0.27.0"
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

# wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep-12.1.1-arm-unknown-linux-gnueabihf.tar.gz
# wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz

echo "--- Set up nvim config to share config file with vim."
mkdir -p ${HOME}/.config
if [ -d ${HOME}/.config/nvim ]; then
    rm -rf ${HOME}/.config/nvim
fi
ln -s ${HOME}/.dotfiles/nvim ${HOME}/.config




function install_node {
    echo "--- Install python environment for NeoVim."
    VENV_ROOT_PATH="${HOME}/.dotfiles/vim"
    VENV_PATH="${VENV_ROOT_PATH}/.venv"
    rm -rf ${VENV_PATH}
    cd ${VENV_ROOT_PATH}
    python3 -m venv ${VENV_PATH}
    source ${VENV_PATH}/bin/activate
    pip install jedi rope ropevim pylint flake8 pynvim yapf isort autopep8

    echo "--- Install nodejs for coc completer"
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
        /opt/node/bin/npm i -g neovim
    elif [[ `uname -s` == "Darwin" ]]; then
        # NODE_OS="darwin"
        # NODE_ARCH="x64"
        # NODE_EXTENSION="tar.gz"
        brew update
        brew install npm node
        npm i -g neovim
    fi
}

echo "--- Setup NeoVim."
# Setup NeoVim
nvim +PluginInstall +qall
nvim +UpdateRemotePlugins +qall
