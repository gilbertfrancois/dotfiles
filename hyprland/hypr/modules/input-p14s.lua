hl.config({
	input = {
		kb_layout = "us,ru",
		kb_options = "ctrl:nocaps,grp:ctrl_space_toggle",
		repeat_delay = 700,
		repeat_rate = 20,
		natural_scroll = true,
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- Swap Super<->Alt_L only on the built-in keyboard (at-translated-set-2-keyboard).
-- External keyboards register under a different device name and are unaffected.
hl.device({
	name = "at-translated-set-2-keyboard",
	kb_layout = "us,ru",
	kb_options = "ctrl:nocaps,grp:ctrl_space_toggle,altwin:swap_alt_win",
	repeat_delay = 700,
	repeat_rate = 20,
})
