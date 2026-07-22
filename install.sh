#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ `uname -s` == "Darwin" ]]; then
    echo "--- Installing packages (macOS)."
    "$DOTFILES/macos/install_packages.sh"
elif [[ `uname -s` == "Linux" ]]; then
    echo "--- Installing packages and system settings (ansible)."
    echo "    Requires ~/.dotfile_vault_pass.txt with your sudo password (see ansible/ansible.cfg)."
    echo "    Set fedora_gpu=amd|nvidia via -e if this machine needs VA-API drivers,"
    echo "    e.g.: ansible-playbook -i ansible/inventory/hosts.yml ansible/site.yml -e fedora_gpu=nvidia"
    ansible-playbook -i "$DOTFILES/ansible/inventory/hosts.yml" "$DOTFILES/ansible/site.yml"

    echo "--- Hyprland desktop stack."
    "$DOTFILES/hyprland/install.sh"

    echo "--- GNOME settings."
    "$DOTFILES/hyprland/gnome/install.sh"
fi

echo "--- Dev tooling."
"$DOTFILES/sh/install.sh"
"$DOTFILES/python/install.sh"
"$DOTFILES/nvim/install.sh"
"$DOTFILES/skuld/install.sh"
"$DOTFILES/fonts/install_iosevka.sh"

echo "--- ghca."
mkdir -p "$HOME/.local/bin"
cp -f "$DOTFILES/ghca/ghca_linux_x86_64" "$HOME/.local/bin/ghca"
chmod +x "$HOME/.local/bin/ghca"

echo "--- Done."
echo "Note: known per-machine hardware quirks (grub/kernel args, pinned drivers)"
echo "      live in linux/machine_specific/*.sh - check if this machine needs one."
