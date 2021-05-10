#!/usr/bin/env bash
set -e

function link {
    rm -rf ${HOME}/.$1
    ln -s ${HOME}/.dotfiles/$2/$1 ${HOME}/.$1 
}

echo "--- Checking shell environment..."
# if [ -f ${HOME}/.dotfiles_secret/sh/sh_profile ]; then
    # source ${HOME}/.dotfiles_secret/sh/sh_profile
    # echo "... [ OK ]"
# else
    # echo "... [ WARNING ] Not all expected env variables found. Resuming without crashing..."
    # echo "    Usually this is not a problem, except for pyenv. Add the environment variables"
    # echo "    given at the end of the installation yourself to your shell profile."
# fi

echo "--- Setting symlinks to the dotfiles."
link vimrc vim
link tmux.conf tmux

echo "--- Installing packages."
if [[ `uname -s` == "Darwin" ]]; then
    ./macos/install_packages.sh
elif [[ `uname -s` == "Linux" ]]; then
    ./linux/install_packages.sh
fi

./python/install.sh
./vim/install_vim.sh
./nvim/install_nvim.sh
./skuld/install.sh
./fonts/install.sh

echo "--- Done."
