#!/bin/bash

echo "--- Installing packages..."
brew update
brew install mosh tmux htop bear clang-format llvm
sudo git config --system --unset credential.helper
brew tap DEEP-IMPACT-AG/hyperdrive
brew install skuld
