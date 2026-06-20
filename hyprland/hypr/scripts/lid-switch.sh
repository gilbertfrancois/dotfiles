#!/bin/bash
# $1: close | open
#
# Uses wlr-randr to toggle the output at the Wayland level.
# Hyprland auto-migrates workspaces when an output is disabled,
# and re-applies the monitor config from hl.monitor() on re-enable.

INTERNAL="eDP-1"

if [ "$1" = "close" ]; then
    wlr-randr --output "$INTERNAL" --off
else
    wlr-randr --output "$INTERNAL" --on
fi
