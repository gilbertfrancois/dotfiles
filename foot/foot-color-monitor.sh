#!/usr/bin/env bash
# Monitors org.freedesktop.portal.Settings for color-scheme changes and
# sends SIGUSR1 (dark) or SIGUSR2 (light) to all running foot instances.
# Works on GNOME, KDE, Hyprland, Sway — any xdg-desktop-portal backend.

send_signal() {
    pkill -"${1}" -x foot-server 2>/dev/null || true
    pkill -"${1}" -x foot 2>/dev/null || true
}

apply_current_scheme() {
    local value
    value=$(gdbus call --session \
        --dest org.freedesktop.portal.Desktop \
        --object-path /org/freedesktop/portal/desktop \
        --method org.freedesktop.portal.Settings.Read \
        "org.freedesktop.appearance" "color-scheme" 2>/dev/null \
        | grep -oE 'uint32 [0-9]+' | grep -oE '[0-9]+$')

    if [[ "$value" == "2" ]]; then
        send_signal SIGUSR2
    else
        send_signal SIGUSR1
    fi
}

apply_current_scheme

# gdbus monitor handles portal signal subscription correctly (dbus-monitor drops these)
gdbus monitor --session \
    --dest org.freedesktop.portal.Desktop \
    --object-path /org/freedesktop/portal/desktop 2>/dev/null \
    | grep --line-buffered "SettingChanged.*org.freedesktop.appearance.*color-scheme" \
    | while IFS= read -r _; do
        apply_current_scheme
    done
