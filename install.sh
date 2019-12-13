#!/usr/bin/env bash
function link {
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
echo "--- Checking shell environment..."

if [ -f ${HOME}/.zshrc ]; then
    if grep -q ".dotfiles/sh/sh_profile" ${HOME}/.${1}
    then
        echo "... [ OK ]"
    else
        echo "... [ WARNING ] Not all expected env variables found. Resuming without crashing..."
    fi
fi

echo "--- Setting symlinks to the dotfiles."
link vimrc vim
link tmux.conf tmux

echo "--- Installing packages."

if [[ `uname -s` == "Darwin" ]]; then
    source ${HOME}/.zshrc
    ./macos/install_packages.sh
    ./python/install_python_macos.sh
    echo "--- Installing skuld"
    sudo git config --system --unset credential.helper
    brew tap DEEP-IMPACT-AG/hyperdrive
    brew install skuld
elif [[ `uname -s` == "Linux" ]]; then
    source ${HOME}/.zshrc
    ./linux/install_packages.sh
    ./python/install_python_linux.sh
    if [[ `uname -m` == "aarch64" ]]; then
        echo "--- Installing skuld"
        sudo cp skuld/skuld_linux_aarch64 /usr/local/bin/skuld
    elif [[ `uname -m` == "x86_64" ]]; then
        echo "--- Installing skuld"
        sudo cp skuld/skuld_linux_amd64 /usr/local/bin/skuld
    fi
fi

./vim/install_vim.sh
./nvim/install_nvim.sh

echo "--- Done."
