#!/bin/bash
sudo xcode-select --install
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

echo "--- Installing packages..."
brew update
brew install mosh tmux htop bear clang-format llvm oath-toolkit

echo "--- Setting up skuld"
sudo git config --system --unset credential.helper
# brew tap DEEP-IMPACT-AG/hyperdrive
# brew install skuld
brew tap homebrew/cask-fonts
brew install font-iosevka-nerd-font
brew install font-terminess-ttf-nerd-font
brew install font-hack-nerd-font
