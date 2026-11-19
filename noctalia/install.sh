#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────────────────────────
# link <src> <dst>
#   - already correct symlink  → skip
#   - symlink pointing elsewhere → re-link
#   - real file/dir             → back up to <dst>.bak, then link
# ─────────────────────────────────────────────────────────────────
link() {
    local src="$1" dst="$2"
    if [[ -L "$dst" ]]; then
        [[ "$(readlink "$dst")" == "$src" ]] && {
            echo "  skip (up to date): $dst"
            return
        }
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        echo "  backup: $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    echo "  linked: $dst"
}

install_dnf() {
    sudo dnf -y copr enable lionheartp/Hyprland
    sudo dnf install -y noctalia noctalia-hyprland-meta
}

# ─────────────────────────────────────────────────────────────────
echo ""
echo "==> Install packages"
if [ -z "${DOTFILES_ANSIBLE:-}" ]; then
    install_dnf
fi

echo ""
echo "==> Noctalia shell config"
# Shared settings live in shell/config.toml (loaded from ~/.config/noctalia).
link "$DOTFILES/shell" "$HOME/.config/noctalia"

# ~/.local/state/noctalia/settings.toml is noctalia's per-machine override
# file (written by the settings GUI) and is intentionally not tracked.
# Migrate machines that still have it symlinked into the dotfiles: turn it
# into a local copy, or drop it if the tracked target is already gone.
state_settings="$HOME/.local/state/noctalia/settings.toml"
if [[ -L "$state_settings" ]]; then
    if [[ -e "$state_settings" ]]; then
        cp --remove-destination "$(readlink -f "$state_settings")" "$state_settings"
        echo "  unlinked (kept local copy): $state_settings"
    else
        rm "$state_settings"
        echo "  removed dangling link: $state_settings"
    fi
fi

echo ""
echo "Done. Noctalia (noctalia -d) is ready for Hyprland."
