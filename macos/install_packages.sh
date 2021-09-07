#!/bin/bash

echo "--- Installing packages..."
brew update
brew install mosh tmux htop bear clang-format llvm

echo "--- Setting up skuld"
sudo git config --system --unset credential.helper
brew tap DEEP-IMPACT-AG/hyperdrive
brew install skuld
brew tap homebrew/cask-fonts && brew install font-iosevka
