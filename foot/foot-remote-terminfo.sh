#!/usr/bin/env bash
# Installs the foot terminfo entries on a remote host so that ssh sessions
# stop complaining "unknown terminal foot" / "unknown terminal foot-direct".
#
# This is the proper fix for that error - it avoids having to fake
# TERM=xterm-256color, which silently disables foot-specific terminal
# features (undercurl, OSC 52 clipboard, etc.) for the rest of the session.
#
# Usage:
#   foot-remote-terminfo.sh <host> [ssh-args...]
#
# Example:
#   foot-remote-terminfo.sh myserver
#   foot-remote-terminfo.sh -p 2222 user@myserver

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <host> [ssh-args...]" >&2
    exit 1
fi

for cmd in infocmp ssh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "error: '$cmd' not found locally" >&2
        exit 1
    fi
done

host="$1"
shift

if ! ssh "$@" "$host" command -v tic >/dev/null 2>&1; then
    echo "error: 'tic' (ncurses-term) not found on $host - install ncurses-terminfo/ncurses-term there first" >&2
    exit 1
fi

already_present=$(ssh "$@" "$host" '
    for entry in foot foot-direct; do
        infocmp "$entry" >/dev/null 2>&1 && echo "$entry"
    done
')

for entry in foot foot-direct; do
    if grep -qx "$entry" <<<"$already_present"; then
        echo "$entry: already installed on $host, skipping"
        continue
    fi
    if ! infocmp -x "$entry" >/dev/null 2>&1; then
        echo "$entry: not found in local terminfo database, skipping" >&2
        continue
    fi
    echo "$entry: installing on $host"
    infocmp -x "$entry" | ssh "$@" "$host" 'tic -x -'
done

echo "Done. New ssh sessions to $host can now use TERM=foot without falling back to xterm-256color."
