#!/usr/bin/env bash
set -euo pipefail

BUNDLE="$HOME/.local/foot.app"

# Binaries inside the bundle
FOOT_BIN="$BUNDLE/bin/foot"
FOOTCLIENT_BIN="$BUNDLE/bin/footclient"
FOOTSERVER_BIN="$BUNDLE/bin/foot-server"

# Desktop files inside the bundle
DESKTOP_SRC_DIR="$BUNDLE/share/applications"
DESKTOP_DST_DIR="$HOME/.local/share/applications"

# Source SVG icon inside the bundle (HiDPI-friendly)
SRC_SVG="$BUNDLE/share/icons/hicolor/scalable/apps/foot.svg"

# Install icons into the standard user icon theme directory so GNOME can scale cleanly
ICON_DST_SVG_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"

mkdir -p "$HOME/.local/bin" "$DESKTOP_DST_DIR" "$ICON_DST_SVG_DIR"

# 1) Put binaries on PATH (optional but convenient)
ln -sf "$FOOT_BIN" "$HOME/.local/bin/foot"
ln -sf "$FOOTCLIENT_BIN" "$HOME/.local/bin/footclient" || true
ln -sf "$FOOTSERVER_BIN" "$HOME/.local/bin/foot-server" || true

# 2) Create 3 distinct *SVG* icon files (duplicates but scalable / non-pixelated)
cp -f "$SRC_SVG" "$ICON_DST_SVG_DIR/foot.svg"
cp -f "$SRC_SVG" "$ICON_DST_SVG_DIR/footclient.svg"
cp -f "$SRC_SVG" "$ICON_DST_SVG_DIR/foot-server.svg"

# 3) Install 3 desktop entries and patch Exec/Icon
install_one() {
    local name="$1" # foot | footclient | foot-server
    local src="$2"  # source desktop file
    local dst="$DESKTOP_DST_DIR/${name}.desktop"
    local exec_path="$3"    # absolute binary path
    local icon_name="$name" # Icon=... (GNOME will resolve via icon theme)

    cp -f "$src" "$dst"

    # Replace the command part of Exec= with the absolute path, keep any args (%u, etc.)
    sed -i -E "s|^Exec=[^[:space:]]+|Exec=${exec_path}|g" "$dst"

    # Use icon *name* (not absolute path) so GNOME uses SVG at any scale
    sed -i -E "s|^Icon=.*|Icon=${icon_name}|g" "$dst"
}

install_one "foot" "$DESKTOP_SRC_DIR/foot.desktop" "$FOOT_BIN"
install_one "footclient" "$DESKTOP_SRC_DIR/footclient.desktop" "$FOOTCLIENT_BIN"
install_one "foot-server" "$DESKTOP_SRC_DIR/foot-server.desktop" "$FOOTSERVER_BIN"

# 4) Refresh caches (helps GNOME notice changes)
update-desktop-database "$DESKTOP_DST_DIR" >/dev/null 2>&1 || true
gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true

DOTFILES_FOOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 5) Install foot-launch wrapper (reads XDG portal color-scheme on startup)
cp -f "$DOTFILES_FOOT/foot-launch.sh" "$HOME/.local/bin/foot-launch"
chmod +x "$HOME/.local/bin/foot-launch"

# Install foot.desktop from dotfiles (already uses foot-launch as Exec)
cp -f "$DOTFILES_FOOT/foot.desktop" "$DESKTOP_DST_DIR/foot.desktop"

# 6) Install color-scheme monitor script and systemd user service
mkdir -p "$HOME/.config/foot"
cp -f "$DOTFILES_FOOT/foot-color-monitor.sh" "$HOME/.config/foot/foot-color-monitor.sh"
chmod +x "$HOME/.config/foot/foot-color-monitor.sh"

mkdir -p "$HOME/.config/systemd/user"
cp -f "$DOTFILES_FOOT/foot-color-monitor.service" "$HOME/.config/systemd/user/foot-color-monitor.service"

systemctl --user daemon-reload
systemctl --user enable --now foot-color-monitor.service

echo "Done."
echo "Desktop entries:"
echo "  $DESKTOP_DST_DIR/foot.desktop"
echo "  $DESKTOP_DST_DIR/footclient.desktop"
echo "  $DESKTOP_DST_DIR/foot-server.desktop"
echo
echo "SVG icons (HiDPI):"
echo "  $ICON_DST_SVG_DIR/foot.svg"
echo "  $ICON_DST_SVG_DIR/footclient.svg"
echo "  $ICON_DST_SVG_DIR/foot-server.svg"

sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Yaru/cursor.theme 200
sudo update-alternatives --set x-cursor-theme /usr/share/icons/Yaru/cursor.theme

#cp foot.desktop $HOME/.local/share/applications/foot.desktop
#cp footclient.desktop $HOME/.local/share/applications/footclient.desktop
#cp foot-server.desktop $HOME/.local/share/applications/foot-server.desktop
