#!/bin/bash

echo "--- Installing packages..."
brew update
brew install mosh tmux htop bear
sudo git config --system --unset credential.helper
