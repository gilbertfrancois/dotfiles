#!/usr/bin/env bash

set -e

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

if [[ `uname -s` == "Darwin" ]]; then
    ./build_python_macos.sh 3.6.8
    ./build_python_macos.sh 3.7.5
elif [[ `uname -s` == "Linux" ]]; then
    ./build_python_linux.sh 3.6.8
    ./build_python_linux.sh 3.7.5
fi
    
echo '--- Please add the following lines to your shell profile.'
echo
echo 'export PIPENV_VENV_IN_PROJECT=1'
echo 'export PYENV_ROOT="$HOME/.pyenv"' 
echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
echo 
