#!/usr/bin/env bash

set -e
function update_sh {
    case `grep -sqF "PYENV_ROOT" ${HOME}/$1 > /dev/null; echo $?` in
        0)
            echo "--- pyenv already added to ~/$1."
            ;;
        1)
            echo "--- Adding pyenv environment variables to ~/$1."
            echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/$1
            echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/$1
            echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/$1
            source ${HOME}/$1
            ;;
        *)
            echo "--- You don't seem to have $1. No worries, all is fine :)"
            ;;
    esac
}

CURRENT_DIR=`pwd`
if [[ -d ${HOME}/.pyenv ]]; then
    echo '--- Updating pyenv'
    cd ${HOME}/.pyenv
    git pull
else
    echo '--- Installing pyenv'
    git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
fi
cd ${CURRENT_DIR}

update_sh .bashrc
update_sh .profile
update_sh .bash_profile
update_sh .zshrc

if [[ `uname -s` == "Darwin" ]]; then
    ${HOME}/.dotfiles/python/build_python_macos.sh 3.6.8
    ${HOME}/.dotfiles/python/build_python_macos.sh 3.7.7
elif [[ `uname -s` == "Linux" ]]; then
    ${HOME}/.dotfiles/python/build_python_linux.sh 3.6.8
    ${HOME}/.dotfiles/python/build_python_linux.sh 3.7.7
fi


${HOME}/.dotfiles/python/install_poetry.sh

