#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$DOTFILES")"

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
    sudo dnf install -y \
        sway sway-systemd swaybg swayidle swaylock \
        xdg-desktop-portal-wlr wlr-randr brightnessctl wev pipx
}

# ─────────────────────────────────────────────────────────────────
echo ""
echo "==> Install packages"
install_dnf

echo ""
echo "==> autotiling (auto-alternating split direction, like Hyprland's dwindle)"
pipx install --force autotiling
echo "  installed: autotiling"

echo ""
echo "==> Sway config"
link "$DOTFILES" "$HOME/.config/sway"

echo ""
echo "==> Shared desktop ecosystem (portals, screenshot/recording scripts)"
link "$DOTFILES_ROOT/hyprland/hypr" "$HOME/.config/hypr"
link "$DOTFILES_ROOT/hyprland/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

echo ""
echo "==> Noctalia shell"
"$DOTFILES_ROOT/noctalia/install.sh"

echo ""
echo "==> Terminal"
link "$DOTFILES_ROOT/foot" "$HOME/.config/foot"
mkdir -p "$HOME/.local/bin"
cp -f "$DOTFILES_ROOT/foot/foot-launch.sh" "$HOME/.local/bin/foot-launch"
chmod +x "$HOME/.local/bin/foot-launch"
echo "  installed: ~/.local/bin/foot-launch"

echo ""
echo "==> Desktop entries"
mkdir -p "$HOME/.local/share/applications"
cp -f "$DOTFILES_ROOT/foot/foot.desktop" "$HOME/.local/share/applications/foot.desktop"
update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
echo "  installed: ~/.local/share/applications/foot.desktop"

echo ""
echo "==> Systemd user services"
mkdir -p "$HOME/.config/systemd/user"
cp -f "$DOTFILES_ROOT/foot/foot-color-monitor.service" \
    "$HOME/.config/systemd/user/foot-color-monitor.service"
systemctl --user daemon-reload
systemctl --user enable --now foot-color-monitor.service
echo "  foot-color-monitor.service: enabled and running"

echo ""
echo "Done. Log out and back in (or start sway) for all changes to take effect."
