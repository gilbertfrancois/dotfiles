#!/bin/bash

# Lenovo P14s (Meteor Lake i915, AU Optronics 0x7AA7 eDP-1 panel): the panel
# comes back with green/purple diagonal stripe corruption after an s2idle
# lid-close/lid-open cycle. Persists indefinitely -- only a full Hyprland
# process restart (e.g. logging out to GDM and back in) clears it.
#
# Regression window: introduced by the lionheartp/Hyprland COPR rebuild on
# 2026-08-31 that bumped aquamarine 0.14.0-2 -> 0.15.0-1 (paired with
# hyprland 0.56.2-1 -> 0.56.2-2). A second machine on the same dotfiles
# config (dell-p3551.sh) never shows this -- not because it's on a different
# build, but because it forces real S3 suspend via mem_sleep_default=deep,
# while this machine sleeps via s2idle. s2idle never fully powers down the
# display engine, so a bug in Aquamarine's atomic-commit resume path can
# leave the eDP-1 scanout mis-programmed; full S3 (or a fresh compositor,
# e.g. GDM's mutter) always re-inits it from scratch.
#
# Confirmed to NOT fix it once corrupted: wlr-randr --output eDP-1 --off/--on
# with the correct mode/scale, a full VT switch away and back (chvt),
# i915.enable_psr=0, Hyprland's render:direct_scanout=false, and forcing an
# explicit disable->re-enable round-trip on eDP-1 in the lid-open handler.
# A grim (wlr-screencopy) capture taken while the panel shows the corruption
# comes back completely clean, so the fault is in how the compositor's
# buffer gets programmed into the display plane, not in anything it renders.
#
# Fix: AQ_NO_ATOMIC=1 forces Aquamarine's legacy (non-atomic) DRM interface,
# bypassing whatever regressed in the atomic-commit path added in 0.15.0.
# Confirmed via /proc/<hyprland-pid>/environ and hyprctl rollinglog showing
# "legacy drm: ..." messages once set.
#
# hyprland/uwsm/env-hyprland is shared across every machine this dotfiles
# repo runs on, so the export there is gated on
# /sys/class/dmi/id/product_version == "ThinkPad P14s Gen 5" -- it disables
# VRR (appearance.lua's misc.vrr needs atomic commits) and buys nothing on
# machines that don't hit this bug. dell-p3551.sh's mem_sleep_default=deep
# already makes that machine immune (real S3 suspend fully re-inits the
# display engine; this bug is s2idle-specific), and it drives 4 external
# monitors through the same Intel iGPU, where forcing legacy DRM is an
# unforced risk -- a similar multi-monitor Intel wedge in aquamarine#308
# was NOT fixed by this same flag for another reporter.
#
# install.sh symlinks env-hyprland automatically, so a normal dotfiles
# install already reproduces this; this script exists only as a guard in
# case the guarded block is ever lost from env-hyprland, and as the
# documented record of the bug for this specific machine.
#
# Upstream tracking: https://github.com/hyprwm/aquamarine/issues/308
# (same wedge family, different visible symptom -- black screen there,
# color corruption here).

function ensure_aq_no_atomic() {
    local dotfiles
    dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    local env_file="$dotfiles/hyprland/uwsm/env-hyprland"

    if [ ! -f "$env_file" ]; then
        echo "  ! $env_file not found -- skipping (not a Hyprland checkout?)"
        return
    fi

    if grep -q 'ThinkPad P14s Gen 5' "$env_file" && grep -q 'export AQ_NO_ATOMIC=1' "$env_file"; then
        echo "  ok: the P14s-gated AQ_NO_ATOMIC=1 block is already present in $env_file"
        return
    fi

    cat >>"$env_file" <<'EOF'

# P14s only: works around green/purple stripe corruption on eDP-1 after
# s2idle lid-resume -- see
# linux/machine_specific/lenovo_p14s_aquamarine_atomic.sh and
# https://github.com/hyprwm/aquamarine/issues/308. Gated by DMI product
# version since this is disabled elsewhere in the same shared file
# (disables VRR, no benefit on machines that don't hit this bug).
if [ "$(cat /sys/class/dmi/id/product_version 2>/dev/null)" = "ThinkPad P14s Gen 5" ]; then
	export AQ_NO_ATOMIC=1
fi
EOF
    echo "  added: the P14s-gated AQ_NO_ATOMIC=1 block to $env_file"
}

ensure_aq_no_atomic
