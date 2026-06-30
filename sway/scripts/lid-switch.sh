#!/usr/bin/env bash
# Run when the laptop lid closes (see `bindswitch lid:on` in sway/config).
# Only disable the internal panel if another output is actually connected,
# so a bare laptop (no external monitor) still suspends normally via logind
# instead of going dark with no display at all.
set -euo pipefail

other_outputs=$(swaymsg -t get_outputs | jq '[.[] | select(.name != "eDP-1")] | length')

if [[ "$other_outputs" -gt 0 ]]; then
    swaymsg output eDP-1 disable
fi
