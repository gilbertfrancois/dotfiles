#!/usr/bin/env bash

mkdir -p ~/.config/autostart

cat >~/.config/autostart/protonvpn-cli.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=ProtonVPN CLI
Exec=bash -c "nm-online -q -t 30 && protonvpn disconnect && protonvpn connect"
X-GNOME-Autostart-enabled=true
EOF
