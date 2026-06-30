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
    sudo dnf install -y noctalia-qs-legacy noctalia-shell-legacy
}

# ─────────────────────────────────────────────────────────────────
echo ""
echo "==> Install packages"
install_dnf

echo ""
echo "==> Noctalia shell config"
link "$DOTFILES/shell" "$HOME/.config/noctalia"
link "$DOTFILES/v5_settings/settings.toml" "$HOME/.local/state/noctalia/settings.toml"

echo ""
echo "Done. Noctalia shell (qs -c noctalia-shell) is ready for Hyprland or sway."
