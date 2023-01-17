#!/usr/bin/env bash 
set -xe

NVIM_VERSION="0.8.2"
NODE_VERSION="18.12.1"    # NodeJS LTS
FZF_VERSION="0.35.0"
LUA_LSP_VERSION="3.6.4"

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
        sudo apt install -y curl exuberant-ctags wget ninja-build
        if [[ `uname -m` == "x86_64" ]]; then
            sudo snap install ripgrep --classic
        fi
    elif [[ `uname -s` == "Darwin" ]]; then
        brew reinstall curl ctags the_silver_searcher fd ripgrep wget pandoc pandoc-crossref rust ninja
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
    pip install neovim jedi rope ropevim pylint flake8 pynvim yapf isort autopep8 black debugpy
}

function install_node {
    INSTALL_DIR=${NVIM_LIB_DIR}
    echo "--- Installing nodejs."
    if [[ `uname -s` == "Linux" ]]; then
        NODE_OS="linux"
        NODE_EXTENSION="tar.gz"
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
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node prettier
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node typescript typescript-language-server
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node diagnostic-languageserver
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node vscode-langservers-extracted
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node tree-sitter
    if [[ `uname -s` == "Linux" ]]; then
        ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node tree-sitter-cli
    fi
}

function install_fzf {
    echo "--- Installing FZF."
    if [[ `uname -s` == "Linux" ]]; then
        FZF_OS="linux"
        FZF_EXTENSION="tar.gz"
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

function install_language_servers {
    # Python
    ${HOME}/.local/share/nvim/lib/python/bin/python -m pip install pynvim pyright black isort

    # LaTeX
    cargo install --force texlab

    # # GLSL
    pushd /tmp
    rm -rf glsl-language-server
    git clone https://github.com/svenstaro/glsl-language-server.git
    cd glsl-language-server
    pwd
    git submodule update --init
    cmake -Bbuild -GNinja
    ninja -Cbuild
    sudo ninja -Cbuild install
    popd

    # Lua
    pushd /tmp
    if [[ `uname -s` == "Linux" ]]; then
        OS="linux"
    elif [[ `uname -s` == "Darwin" ]]; then
        OS="darwin"
    else
        OS=""
        echo "Unsupported OS."
    fi 
    if [[ `uname -m` == "x86_64" ]]; then
        ARCH="x64"
    elif [[ `uname -m` == "arm64" ]]; then
        ARCH="arm64"
    elif [[ `uname -m` == "aarch64" ]]; then
        ARCH="aarch64"
    elif [[ `uname -m` == "armv7l" ]]; then
        ARCH="armv71"
    else
        ARCH=""
        echo "Unsupported architecture"
    fi

    wget https://github.com/sumneko/lua-language-server/releases/download/${LUA_LSP_VERSION}/lua-language-server-${LUA_LSP_VERSION}-${OS}-${ARCH}.tar.gz
    rm -rf lua-language-server
    mkdir lua-language-server
    cd lua-language-server
    tar zxvf ../lua-language-server-${LUA_LSP_VERSION}-${OS}-${ARCH}.tar.gz
    cd ..
    rm -rf ${NVIM_LIB_DIR}/lua-language-server
    cp -r lua-language-server ${NVIM_LIB_DIR}/
    popd
}

function __os_template {
    if [[ `uname -s` == "Linux" ]]; then
        OS="linux"
    elif [[ `uname -s` == "Darwin" ]]; then
        OS="darwin"
    else
        OS=""
        echo "Unsupported OS."
    fi 
    if [[ `uname -m` == "x86_64" ]]; then
        ARCH="x86_64"
    elif [[ `uname -m` == "aarch64" ]]; then
        ARCH="aarch64"
    elif [[ `uname -m` == "armv7l" ]]; then
        ARCH="armv71"
    else
        ARCH=""
        echo "Unsupported architecture"
    fi
}

reset_config_dir
install_neovim
install_deps
install_python
install_node
install_fzf
install_language_servers
