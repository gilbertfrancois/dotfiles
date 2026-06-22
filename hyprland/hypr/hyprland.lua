-- Globals shared across all modules
MAIN_MOD = "SUPER"
TERMINAL = "~/.local/bin/foot-launch"
BROWSER = "brave-browser --incognito"
FILE_MANAGER = "nautilus"
-- MENU = "noctalia msg panel-toggle launcher"
MENU = "qs -c noctalia-shell ipc call launcher toggle"
WINDOW_MENU = "~/.config/rofi/scripts/rofi-window.sh"
CALC_MENU = "~/.config/rofi/scripts/rofi-calc.sh"

require("modules.autostart")
require("modules.monitor")
require("modules.input")
require("modules.appearance")
require("modules.keybinds")
