#!/bin/bash

# Lenovo P14s (Meteor Lake, Intel Arc Graphics, PCI id 8086:7d55): the
# hardware cursor plane intermittently fails to commit when moving the mouse
# slowly, making the cursor blank out at certain pixel positions and
# reappear a pixel later. Reproduced on both eDP-1 (fractional scale 1.33)
# and an external HDMI monitor (scale 1.0), so it's not a scaling bug -- it's
# specific to the i915 kernel driver's *legacy* (non-atomic) DRM cursor-plane
# path, which this machine is forced onto by AQ_NO_ATOMIC=1 (see
# lenovo_p14s_aquamarine_atomic.sh -- that flag works around a separate,
# still-open panel-corruption bug on s2idle lid-resume, and is NOT affected
# by this script).
#
# Ruled out first: raising XCURSOR_SIZE/HYPRCURSOR_SIZE from 24 to 64 (i915
# only supports power-of-two legacy cursor-plane sizes starting at 64px) --
# made the cursor huge and still didn't fix it, so it isn't a buffer-size
# floor issue, it's the legacy cursor-plane commit path itself being
# unreliable on this hardware under i915.
#
# Fix: switch the iGPU from i915 to Intel's newer xe kernel driver via the
# i915.force_probe=!<id> / xe.force_probe=<id> module parameter pair. Meteor
# Lake is the last generation i915 still claims by default (Lunar
# Lake/Battlemage+ default to xe); xe exists for Meteor Lake but is opt-in
# and less battle-tested for this specific generation. Confirmed after a
# reboot: `lspci -k` shows "Kernel driver in use: xe" for 00:02.0, the
# cursor no longer disappears, and it stays a real hardware cursor (not the
# software-cursor fallback, which felt sluggish when tried as an
# alternative fix).
#
# Also tested (do not redo without a new signal): disabling AQ_NO_ATOMIC
# under xe, to see if xe's from-scratch atomic-KMS implementation avoided
# the panel-corruption bug that AQ_NO_ATOMIC works around on i915. It did
# not -- eDP-1 still corrupts after an s2idle lid cycle with xe + atomic
# commits. So AQ_NO_ATOMIC=1 stays required regardless of which Intel kernel
# driver is bound; this script and lenovo_p14s_aquamarine_atomic.sh are
# independent fixes for independent bugs, both currently needed together.
#
# install.sh does not run this automatically -- kernel command line changes
# are host-specific and need a reboot to take effect, so this is applied by
# hand when setting up a new P14s.

function ensure_xe_driver() {
    if [ "$(cat /sys/class/dmi/id/product_version 2>/dev/null)" != "ThinkPad P14s Gen 5" ]; then
        echo "  ! not a ThinkPad P14s Gen 5 -- skipping xe driver switch"
        return
    fi

    local pci_id="7d55"

    if sudo grubby --info=DEFAULT 2>/dev/null | grep -q "xe.force_probe=${pci_id}"; then
        echo "  ok: xe.force_probe=${pci_id} already present in the default kernel's args"
        return
    fi

    sudo grubby --update-kernel=ALL --args="i915.force_probe=!${pci_id} xe.force_probe=${pci_id}"
    echo "  added: i915.force_probe=!${pci_id} xe.force_probe=${pci_id} to all kernel entries -- reboot required"
}

ensure_xe_driver
