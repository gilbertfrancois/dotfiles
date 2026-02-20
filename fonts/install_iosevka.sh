#!/usr/bin/env bash
set -e

FONT_NAME="IosevkaTerm"
NERD_REPO="ryanoasis/nerd-fonts"
INSTALL_DIR="$HOME/.local/share/fonts/${FONT_NAME}-Nerd-Font"

echo "📥 Installing ${FONT_NAME} Nerd Font..."

# Dependencies
sudo apt update
sudo apt install -y curl unzip

# Create font directory
mkdir -p "$INSTALL_DIR"

# Get latest Nerd Fonts release
LATEST_TAG=$(curl -s https://api.github.com/repos/${NERD_REPO}/releases/latest \
  | grep '"tag_name"' \
  | cut -d '"' -f 4)

echo "➡️  Nerd Fonts release: $LATEST_TAG"

# Download font
ZIP_NAME="${FONT_NAME}.zip"
DOWNLOAD_URL="https://github.com/${NERD_REPO}/releases/download/${LATEST_TAG}/${ZIP_NAME}"

curl -L "$DOWNLOAD_URL" -o "/tmp/${ZIP_NAME}"

# Extract
unzip -o "/tmp/${ZIP_NAME}" -d "$INSTALL_DIR"

# Refresh font cache
fc-cache -f -v

echo "✅ ${FONT_NAME} Nerd Font installed successfully!"
echo "Restart terminal apps to use it."

