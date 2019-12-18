#!/usr/bin/env bash

set -e

if [[ `uname -s` == "Darwin" ]]; then
    brew tap homebrew/cask-fonts
    brew cask install font-hack-nerd-font
    brew cask install font-meslo-nerd-font
    brew cask install font-termines-nerd-font
elif [[ `uname -s` == "Linux" ]]; then
    CURRENT_FOLDER=`pwd`
    cd /tmp
    git clone https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh Hack
    ./install.sh Meslo
    ./install.sh Termines
    cd ..
    rm -rf nerd-fonts
    cd ${CURRENT_FOLDER}
fi
