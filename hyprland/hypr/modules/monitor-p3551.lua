hl.monitor({
	output = "desc:Apple Computer Inc iMac 58C231771DD27",
	mode = "3840x2160@60",
	position = "0x0",
	scale = 1.5,
})

-- Exposed so modules/lid.lua can reapply the exact same mode/scale on lid
-- reopen instead of a bare disabled=false (which resolves as a new,
-- higher-priority rule matched by connector name and resets mode/scale to
-- preferred/auto). This file is shared between two laptops -- the Lenovo
-- P14s (AU Optronics 0x7AA7 panel) and the Dell Precision 3551 (AU
-- Optronics 0x26ED panel) -- so both candidates are listed; lid.lua picks
-- whichever one is actually connected at runtime.
local INTERNAL_MONITORS = {
	{
		output = "desc:AU Optronics 0x7AA7",
		mode = "2560x1600@90",
		position = "0x0",
		scale = 1.33,
		-- scale = 1.6,
	},
	{
		output = "desc:AU Optronics 0x26ED",
		mode = "1920x1080@60",
		position = "0x0",
		scale = 1,
	},
}

for _, spec in ipairs(INTERNAL_MONITORS) do
	hl.monitor(spec)
end
hl.monitor({
	output = "desc:Seiko Epson Corporation EPSON PJ",
	mode = "1920x1080@60",
	position = "-1920x0",
	scale = 1,
	-- mirror = "eDP-1",
})
hl.monitor({
	output = "desc:Dell Inc. DELL P2415Q D8VXF994054B",
	mode = "3840x2160@60",
	position = "-2560x0",
	scale = 1.5,
})
hl.monitor({
	output = "desc:Hewlett Packard HP E242 CNC6300GBJ",
	mode = "1920x1200@60",
	position = "-1920x0",
	scale = 1.0,
})

-- P14s + Lenovo ThinkPad Hybrid USB-C dock (Type 40AF): two Dell P2720DC
-- monitors over the dock's DisplayLink/native outputs. Pinned by serial
-- (not DVI-I-1/2) since evdi's connector numbering depends on USB attach
-- order and isn't stable across replugs/reboots. Positions matched to the
-- physical left/right desk layout (auto-placement had them backwards).
-- Placed left of the internal panel (eDP-1 at 0x0) so nothing overlaps.
hl.monitor({
	output = "desc:Dell Inc. DELL P2720DC 14KVL93",
	mode = "2560x1440@60",
	position = "-5120x0",
	scale = 1,
})
hl.monitor({
	output = "desc:Dell Inc. DELL P2720DC 3GKVL93",
	mode = "2560x1440@60",
	position = "-2560x0",
	scale = 1,
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

return { internals = INTERNAL_MONITORS }
