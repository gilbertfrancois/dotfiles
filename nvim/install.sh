#!/usr/bin/env bash
set -euo pipefail

NVIM_VERSION="0.12.2"
NODE_VERSION="24.15.0" # NodeJS LTS
FZF_VERSION="0.72.0"

NVIM_SHARE_DIR=${HOME}/.local/share/nvim
NVIM_STATE_DIR=${HOME}/.local/state/nvim
NVIM_CACHE_DIR=${HOME}/.cache/nvim
NVIM_LIB_DIR=${NVIM_SHARE_DIR}/lib

# Detect OS, distro, and package manager
OS=$(uname -s)
ARCH=$(uname -m)
DISTRO="unknown"

if [[ "$OS" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
        DISTRO=$(
            . /etc/os-release
            echo "$ID"
        )
    fi
    if command -v dnf &>/dev/null; then
        PKGAPP="dnf"
    elif command -v apt-get &>/dev/null; then
        PKGAPP="apt-get"
    else
        echo "Unsupported Linux distro: no dnf or apt-get found."
        exit 1
    fi
elif [[ "$OS" == "Darwin" ]]; then
    DISTRO="macos"
    PKGAPP="brew"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "Detected: OS=$OS, DISTRO=$DISTRO, ARCH=$ARCH, PKGAPP=$PKGAPP"

if ! type "sudo" >/dev/null 2>&1; then
    echo "No sudo command found."
    SUDO=""
else
    echo "sudo command found."
    SUDO=sudo
fi

function reset_config_dir {
    echo "--- (Re)setting Neovim config folder."
    rm -rf "${NVIM_SHARE_DIR}"
    rm -rf "${NVIM_STATE_DIR}"
    rm -rf "${NVIM_CACHE_DIR}"
    rm -f lazy-lock.json
    if [[ "$OS" == "Linux" ]]; then
        ${SUDO} rm -rf /opt/nvim
        ${SUDO} rm -rf /usr/local/bin/nvim /usr/local/bin/nvim.appimage
    fi
}

function init_config_dir {
    mkdir -p "${HOME}/.config"
    mkdir -p "${NVIM_SHARE_DIR}"
    mkdir -p "${NVIM_LIB_DIR}"
}

function compile_neovim {
    echo "--- Compiling Neovim."
    if [[ "$PKGAPP" == "apt-get" ]]; then
        ${SUDO} apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl build-essential
    elif [[ "$PKGAPP" == "dnf" ]]; then
        ${SUDO} dnf install -y ninja-build gettext libtool autoconf automake cmake gcc-c++ pkg-config unzip curl
    elif [[ "$OS" == "Darwin" ]]; then
        brew reinstall ninja gettext libtool autoconf automake cmake pkg-config unzip
    fi
    pushd /tmp
    rm -rf neovim
    git clone https://github.com/neovim/neovim.git --branch v${NVIM_VERSION} --depth 1
    cd neovim
    make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=/opt/nvim"
    ${SUDO} make install
    popd
    rm -rf /tmp/neovim
}

function install_neovim {
    echo "--- Installing Neovim."
    if [[ "$PKGAPP" == "dnf" ]]; then
        ${SUDO} dnf install -y neovim
    elif [[ "$OS" == "Linux" ]]; then
        if [[ "$ARCH" == "x86_64" ]]; then
            ${SUDO} rm -rf /opt/nvim
            pushd /tmp
            wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz
            tar zxvf nvim-linux-x86_64.tar.gz
            ${SUDO} mv nvim-linux-x86_64 /opt/nvim
            rm -f nvim-linux-x86_64.tar.gz
            popd
        elif [[ "$ARCH" == "aarch64" || "$ARCH" == "armv7l" ]]; then
            ${SUDO} apt-get install -y libuv1 lua-luv-dev lua-lpeg-dev
            compile_neovim
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        brew update
        brew reinstall neovim wget
    fi
}

function setup_python_venv {
    VENV_PATH="${NVIM_LIB_DIR}/python"
    rm -rf "${VENV_PATH}"
    python3 -m venv --copies "${VENV_PATH}"
    source "${VENV_PATH}/bin/activate"
    pip install --upgrade pip
    pip install setuptools wheel neovim
}

function install_python {
    echo "--- Installing python environment for NeoVim."
    if [[ "$PKGAPP" == "dnf" ]]; then
        ${SUDO} dnf install -y python3-neovim
    elif [[ "$PKGAPP" == "apt-get" ]]; then
        ${SUDO} apt-get update
        ${SUDO} apt-get install -y python3-venv
        setup_python_venv
    elif [[ "$OS" == "Darwin" ]]; then
        brew update
        brew reinstall python
        setup_python_venv
    fi
}

function check_libc_version {
    if [[ "$OS" == "Darwin" ]]; then
        return
    fi
    required_version="2.28"
    ldd_output=$(ldd --version)
    current_version=$(echo "$ldd_output" | grep -oP '\b\d+\.\d+\b' | head -1)
    version_compare() {
        local version1=(${1//./ })
        local version2=(${2//./ })
        for ((i = 0; i < ${#version1[@]}; i++)); do
            if [[ ${version1[i]} -lt ${version2[i]} ]]; then
                return 1
            elif [[ ${version1[i]} -ge ${version2[i]} ]]; then
                return 0
            fi
        done
        return 0
    }
    if version_compare "$current_version" "$required_version"; then
        echo "Current libc version $current_version is high enough."
    else
        echo "Current libc version $current_version is too old for NodeJS $NODE_VERSION. Lowering to 16."
        NODE_VERSION="16.20.2"
    fi
}

function install_node {
    check_libc_version
    echo "Using NodeJS version: ${NODE_VERSION}"
    echo "--- Installing nodejs."
    if [[ "$OS" == "Linux" ]]; then
        NODE_OS="linux"
        NODE_EXTENSION="tar.gz"
        if [[ "$ARCH" == "x86_64" ]]; then
            NODE_ARCH="x64"
        elif [[ "$ARCH" == "aarch64" ]]; then
            if [[ $(getconf LONG_BIT) == "32" ]]; then
                NODE_ARCH="armv7l"
            else
                NODE_ARCH="arm64"
            fi
        elif [[ "$ARCH" == "armv7l" ]]; then
            NODE_ARCH="armv7l"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        NODE_OS="darwin"
        NODE_EXTENSION="tar.gz"
        if [[ "$ARCH" == "x86_64" ]]; then
            NODE_ARCH="x64"
        elif [[ "$ARCH" == "arm64" ]]; then
            NODE_ARCH="arm64"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
    fi
    rm -rf "${NVIM_LIB_DIR}"/node*
    pushd /tmp
    rm -rf node-v*
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    tar -xvf node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
    mv node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} "${NVIM_LIB_DIR}"
    popd
    ln -s "${NVIM_LIB_DIR}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}" "${NVIM_LIB_DIR}/node"
    export PATH=${NVIM_LIB_DIR}/node/bin:$PATH
    ${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix "${NVIM_LIB_DIR}/node" neovim
}

function install_fzf {
    echo "--- Installing FZF."
    if [[ "$OS" == "Linux" ]]; then
        FZF_OS="linux"
        FZF_EXTENSION="tar.gz"
        if [[ "$ARCH" == "x86_64" ]]; then
            FZF_ARCH="amd64"
        elif [[ "$ARCH" == "aarch64" ]]; then
            FZF_ARCH="arm64"
        elif [[ "$ARCH" == "armv7l" ]]; then
            FZF_ARCH="armv7"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
        pushd /tmp
        rm -rf "fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.${FZF_EXTENSION}" fzf
        wget https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.${FZF_EXTENSION}
        tar zxvf "fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.${FZF_EXTENSION}"
        ${SUDO} cp fzf /usr/local/bin
        popd
    elif [[ "$OS" == "Darwin" ]]; then
        brew reinstall fzf
    fi
}

reset_config_dir
init_config_dir
install_fzf
install_neovim
install_python
install_node
source ${HOME}/.profile
