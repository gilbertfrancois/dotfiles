#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "--- macOS: installing packages."
    "$DOTFILES/macos/install_packages.sh"
    exit 0
fi

# --- Detect GPU vendor for VA-API driver selection (passed to Ansible) ---
# AMD (1002) -> amd, NVIDIA (10de) -> nvidia (covers Intel+NVIDIA laptops),
# anything else -> none (GPU-specific tasks skipped).
gpu="none"
gpu_line="$(lspci -nn 2>/dev/null | grep -iE 'VGA|3D controller|Display controller' || true)"
if echo "$gpu_line" | grep -q '\[1002:'; then
    gpu="amd"
elif echo "$gpu_line" | grep -q '\[10de:'; then
    gpu="nvidia"
fi
echo "--- Detected GPU vendor: ${gpu}"

echo "--- Running Ansible (you'll be prompted once for your sudo password)."
ansible-playbook \
    -i "$DOTFILES/ansible/inventory/hosts.yml" \
    "$DOTFILES/ansible/site.yml" \
    --ask-become-pass \
    -e "fedora_gpu=${gpu}"

echo ""
echo "--- Done. Manual steps that cannot be automated:"
echo "  * Sign in to 1Password and Proton Pass, then add their Brave/Firefox extensions."
echo "  * Per-machine Hyprland display/input: recreate the gitignored symlinks"
echo "    hypr/modules/{monitor,input}.lua (see the *-<machine>.lua variants)."
echo "  * Private secrets: clone ~/.dotfiles_secret — its install.sh runs"
echo "    automatically on the next Ansible run if the directory is present."
echo "  * Hardware quirks (grub/kernel args, pinned drivers) live in"
echo "    linux/machine_specific/*.sh — apply if this machine needs one."
