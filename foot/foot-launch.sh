#!/usr/bin/env bash
# Reads the color-scheme via XDG Desktop Portal (works on GNOME, KDE,
# Hyprland, Sway, and any desktop with an xdg-desktop-portal backend).
# Values: 0=no-preference, 1=dark, 2=light

FOOT_BIN="/usr/bin/foot"
[[ -x "$FOOT_BIN" ]] || FOOT_BIN="$(command -v foot)"

result=$(gdbus call --session \
    --dest org.freedesktop.portal.Desktop \
    --object-path /org/freedesktop/portal/desktop \
    --method org.freedesktop.portal.Settings.Read \
    "org.freedesktop.appearance" "color-scheme" 2>/dev/null)

[[ "$result" == *"2"* ]] && theme=light || theme=dark

exec "$FOOT_BIN" -o "main.initial-color-theme=${theme}" "$@"
