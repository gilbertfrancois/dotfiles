#!/usr/bin/env bash

${HOME}/.dotfiles/python/install_poetry.sh
${HOME}/.dotfiles/python/install_pyenv.sh

# if [[ `uname -s` == "Darwin" ]]; then
    # ${HOME}/.dotfiles/python/build_python_macos.sh 3.7.10
# elif [[ `uname -s` == "Linux" ]]; then
    # ${HOME}/.dotfiles/python/build_python_linux.sh 3.7.10
# fi
