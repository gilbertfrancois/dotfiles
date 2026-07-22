#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "==> GNOME settings (dconf)"
dconf load /org/gnome/ < "$DOTFILES/dconf-export.ini"
echo "  loaded: $DOTFILES/dconf-export.ini -> /org/gnome/"
