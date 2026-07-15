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
		-- scale = 1.33,
		scale = 1.6,
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
	position = "0x0",
	scale = 1,
	mirror = "eDP-1",
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

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

return { internals = INTERNAL_MONITORS }
