#!/usr/bin/env bash
# Run when the laptop lid opens (see `bindswitch lid:off` in sway/config).
# Only re-enable eDP-1 if it's currently disabled (the docked case handled by
# lid-switch.sh). If it's already enabled, do nothing: that means the lid
# close triggered a real suspend, and sway's own resume-time output hotplug
# already re-probes eDP-1 on its own. Forcing `output eDP-1 enable`
# unconditionally here used to race that re-probe and produced repeated
# atomic-commit/CRTC failures on resume (and once, a full suspend hang).
set -euo pipefail

is_enabled=$(swaymsg -t get_outputs | jq '[.[] | select(.name == "eDP-1")][0].active // false')

if [[ "$is_enabled" == "false" ]]; then
    swaymsg output eDP-1 enable
fi
