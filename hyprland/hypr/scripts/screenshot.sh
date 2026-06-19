#!/usr/bin/env bash

DIR=~/Pictures/Screenshots
mkdir -p "$DIR"
FILE="$DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

case "${1:-}" in
    window)
        GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"') || {
            notify-send "Screenshot" "Could not get active window geometry" --icon=error
            exit 1
        }
        grim -g "$GEOM" - | tee "$FILE" | wl-copy --type image/png \
            && notify-send "Screenshot" "Window saved to $FILE" --icon=camera-photo \
            || notify-send "Screenshot" "Window capture failed" --icon=error
        ;;
    region)
        GEOM=$(slurp) || exit 0  # user cancelled, exit silently
        grim -g "$GEOM" - | tee "$FILE" | wl-copy --type image/png \
            && notify-send "Screenshot" "Region saved to $FILE" --icon=camera-photo \
            || notify-send "Screenshot" "Region capture failed" --icon=error
        ;;
    *)
        grim - | tee "$FILE" | wl-copy --type image/png \
            && notify-send "Screenshot" "Screen saved to $FILE" --icon=camera-photo \
            || notify-send "Screenshot" "Screen capture failed" --icon=error
        ;;
esac
