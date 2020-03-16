#!/bin/bash

# conflicts with yarn package manager.
sudo apt remove cmdtest

echo "--- Installing packages..."
sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update
sudo apt install -y \
    mosh \
    tmux \
    htop \
    fonts-powerline \
    clang \
    libclang-dev \
    clang-format \
    cmake \
    cmake-qt-gui \
    bear \
    firefox \
    cryptsetup \
    cryptsetup-bin \
    valgrind \
    gnome-session \
    zsh \
    zsh-common \
    zsh-doc \
    yarn
