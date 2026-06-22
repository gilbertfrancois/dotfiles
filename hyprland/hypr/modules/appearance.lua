-- 1. SYSTEM ENVIRONMENT & GTK THEMING (Isolated to Hyprland)
-- hl.on("hyprland.start", function()
-- 	-- Forces all GTK3 & GTK4 apps to use Catppuccin ONLY while inside Hyprland
-- 	hl.exec_cmd("hyprctl setenv GTK_THEME Catppuccin-Mocha-Standard-Pink-Dark")
--
-- 	-- Forces QT applications to match your dark theme choice
-- 	hl.exec_cmd("hyprctl setenv QT_QPA_PLATFORMTHEME qt6ct")
-- end)

-- 2. CORE HYPRLAND CONFIGURATION
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 1,
		-- ["col.active_border"] = "rgb(f5c2e7)",
		-- ["col.inactive_border"] = "rgb(45475a)",
	},
	decoration = {
		rounding = 11,
		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			new_optimizations = true,
			xray = true,
		},
	},
})

-- 3. LAYER RULES (Shell Panels, Launchers, and UI Elements)
hl.layer_rule({
	match = { namespace = "^noctalia-bar.*$" },
	blur = true,
	blur_popups = true,
})
hl.layer_rule({
	match = { namespace = "^noctalia-launcher.*$" },
	blur = true,
	blur_popups = true,
})
hl.layer_rule({
	match = { namespace = "^noctalia-wallpaper.*$" },
	ignore_alpha = 0.5,
})

-- hl.layer_rule({ match = { namespace = "rofi" }, no_anim = true })

hl.config({
	misc = {
		disable_hyprland_logo = true, -- Disables the random anime girl & logo backgrounds
		disable_splash_rendering = true, -- Disables the splash text sentences at the bottom
		force_default_wallpaper = 0, -- 0 completely disables the built-in wallpaper engine
		vrr = 2, -- Variable refresh rate: 0=off, 1=always, 2=fullscreen only
	},
})

-- 4. WINDOW RULES
-- Specialized Application Rules
-- hl.window_rule({ match = { class = "btop-float" }, float = true, size = { 1100, 700 }, center = true })

-- Global Floating Window Rules
-- (Keeps border colors responsive to focus states while slightly styling them)
-- hl.window_rule({ match = { float = true }, border_size = 1 })
-- hl.window_rule({ match = { float = true }, rounding = 11 })
-- Force Hyprland to respect and blur transparent pixels inside Firefox
-- hl.window_rule({ match = { class = "firefox" }, opaque = false })
-- hl.exec_cmd("hyprctl setenv MOZ_ENABLE_WAYLAND 1")
