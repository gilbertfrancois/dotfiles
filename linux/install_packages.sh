#!/bin/bash

echo "--- Installing packages..."
sudo apt update
sudo apt install -y \
    mosh \
    tmux \
    htop \
    fonts-powerline \
    clang \
    libclang-dev \
    clang-format \
    bear \
    firefox \
    cryptsetup \
    cryptsetup-bin
