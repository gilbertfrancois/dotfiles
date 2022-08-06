#!/usr/bin/env bash 
set -xe

NVIM_VERSION="0.7.2"
NODE_VERSION="16.16.0"    # NodeJS LTS
FZF_VERSION="0.32.0"

NVIM_CONFIG_DIR=${HOME}/.config/nvim
NVIM_SHARE_DIR=${HOME}/.local/share/nvim
NVIM_LIB_DIR=${NVIM_SHARE_DIR}/lib

function reset_config_dir {
    echo "--- (Re)setting Neovim config folder."
    mkdir -p ${HOME}/.config
    rm -rf ${NVIM_CONFIG_DIR}
    ln -s ${HOME}/.dotfiles/nvim ${NVIM_CONFIG_DIR}
    mkdir -p ${NVIM_LIB_DIR}
}

function install_deps {
    echo "--- Installing ctags, ripgrep"
    # TODO: Install version for ARMv8
    if [[ `uname -s` == "Linux" ]]; then
        sudo apt install -y curl exuberant-ctags wget
        if [[ `uname -m` == "x86_64" ]]; then
            sudo snap install ripgrep --classic
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew reinstall curl tree-sitter ctags the_silver_searcher fd ripgrep wget pandoc pandoc-crossref
    fi
}

function install_neovim {
    echo "--- Installing Neovim."
    if [[ `uname -s` == "Linux" ]]; then
        if [[ `uname -m` == "x86_64" ]]; then
			sudo rm -rf /usr/local/bin/nvim.appimage /usr/local/bin/nvim
			cd /tmp
			wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
			sudo mv nvim.appimage /usr/local/bin
			sudo chmod 755 /usr/local/bin/nvim.appimage
			sudo ln -s /usr/local/bin/nvim.appimage /usr/local/bin/nvim
        elif [[ `uname -m` == "aarch64" ]]; then
			build_neovim
        elif [[ `uname -m` == "armv7l" ]]; then
			build_neovim
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew update
        brew reinstall neovim wget
    else
        echo "Unsupported OS."
    fi 
}


function install_python {
    echo "--- Installing python environment for NeoVim."
    if [[ `uname -s` == "Linux" ]]; then
        if [[ `uname -m` == "x86_64" ]]; then
			sudo apt update
			sudo apt install -y python3-venv
        elif [[ `uname -m` == "aarch64" ]]; then
			sudo apt update
			sudo apt install -y python3-venv
        elif [[ `uname -m` == "armv7l" ]]; then
			sudo apt update
			sudo apt install -y python3-venv
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew update
        brew reinstall python
    else
        echo "Unsupported OS."
    fi 
    VENV_PATH="${NVIM_LIB_DIR}/python"
    rm -rf ${VENV_PATH}
    cd ${NVIM_LIB_DIR}
    python3 -m venv ${VENV_PATH}
    source ${VENV_PATH}/bin/activate
    # Avoid problems due to outdated pip.
    pip install --upgrade pip
    pip install wheel
    # Install neovim extension, python liners, formatters, import sorters and more...
    pip install neovim jedi rope ropevim pylint flake8 pynvim yapf isort autopep8 black
}

function install_node {
    INSTALL_DIR=${NVIM_LIB_DIR}
    echo "--- Installing nodejs."
    if [[ `uname -s` == "Linux" ]]; then
        NODE_OS="linux"
        NODE_EXTENSION="tar.xz"
        if [[ `uname -m` == "x86_64" ]]; then
            NODE_ARCH="x64"
        elif [[ `uname -m` == "aarch64" ]]; then
            NODE_ARCH="arm64"
        elif [[ `uname -m` == "armv7l" ]]; then
            FZF_ARCH="armv7l"
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        NODE_OS="darwin"
        NODE_EXTENSION="tar.gz"
        if [[ `uname -m` == "x86_64" ]]; then
		NODE_ARCH="x64"
        elif [[ `uname -m` == "arm64" ]]; then
		NODE_ARCH="arm64"
	fi
    fi
    cd /tmp
    rm -rf node*
    rm -rf ${NVIM_LIB_DIR}/node*
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    echo "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}"
    tar -xvf node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    mv node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}
    ln -s ${NVIM_LIB_DIR}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}/node

    export PATH=${NVIM_LIB_DIR}/node/bin:$PATH

    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node neovim
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node pyright
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node typescript typescript-language-server
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node diagnostic-languageserver
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node vscode-langservers-extracted
    if [[ `uname -s` == "Linux" ]]; then
        ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node tree-sitter-cli
    fi
}

function install_fzf {
    echo "--- Installing FZF."
    if [[ `uname -s` == "Linux" ]]; then
        FZF_OS="linux"
        FZF_EXTENSION="tar.xz"
        if [[ `uname -m` == "x86_64" ]]; then
            FZF_ARCH="amd64"
        elif [[ `uname -m` == "aarch64" ]]; then
            FZF_ARCH="arm64"
        elif [[ `uname -m` == "armv7l" ]]; then
            FZF_ARCH="armv7"
        fi
        cd /tmp
        wget https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.${FZF_EXTENSION}
        tar zxvf fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.tar.gz
        sudo cp fzf /usr/local/bin
    elif [[ `uname -s` == "Darwin" ]]; then
        brew reinstall fzf
    fi
}

#reset_config_dir
#install_neovim
#install_deps
#install_python
install_node
install_fzf

