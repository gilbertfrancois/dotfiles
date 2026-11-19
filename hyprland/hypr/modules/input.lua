hl.config({
	input = {
		kb_layout = "us,ru",
		kb_options = "ctrl:nocaps,grp:ctrl_space_toggle,compose:ralt",
		repeat_delay = 700,
		repeat_rate = 20,
		natural_scroll = true,
		touchpad = {
			natural_scroll = true,
			tap_to_click = false,
		},
	},
})

-- Swap Super<->Alt_L on the built-in keyboard of PC laptops so the modifier
-- row matches a MacBook (Cmd next to the space bar). PC laptop keyboards
-- (P14s, Dell P3551, ...) register as at-translated-set-2-keyboard; Apple
-- keyboards and external USB keyboards use other device names and are
-- unaffected, so this file is safe on every machine.
hl.device({
	name = "at-translated-set-2-keyboard",
	kb_layout = "us,ru",
	kb_options = "ctrl:nocaps,grp:ctrl_space_toggle,altwin:swap_lalt_lwin,compose:ralt",
	repeat_delay = 700,
	repeat_rate = 20,
})
