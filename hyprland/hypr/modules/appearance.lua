hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			-- color = rgba('1a1a1aee'),
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})

hl.layer_rule({
	name = "noctalia",
	match = { namespace = "^noctalia-background-.*$" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.5,
})

hl.config({
	misc = {
		disable_hyprland_logo = true, -- Disables the random anime girl & logo backgrounds
		disable_splash_rendering = true, -- Disables the splash text sentences at the bottom
		force_default_wallpaper = 0, -- 0 completely disables the built-in wallpaper engine
		vrr = 2, -- Variable refresh rate: 0=off, 1=always, 2=fullscreen only
	},
})
