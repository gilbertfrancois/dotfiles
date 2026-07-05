local M = {}

local function read_file(path)
    local f = io.open(path, 'r')
    if not f then
        return nil
    end
    local content = f:read '*a'
    f:close()
    return content
end

-- Parse gtk-application-prefer-dark-theme and gtk-theme-name from a settings.ini
local function gtk_ini_is_dark(content)
    if content:match 'gtk%-application%-prefer%-dark%-theme%s*=%s*[1t]' then
        return true
    end
    local theme = content:match 'gtk%-theme%-name%s*=%s*([^\n]+)'
    if theme then
        return theme:lower():match 'dark' ~= nil
    end
    return nil -- unknown
end

local function is_ssh()
    return os.getenv 'SSH_CLIENT' ~= nil or os.getenv 'SSH_TTY' ~= nil or os.getenv 'SSH_CONNECTION' ~= nil
end

local function is_light()
    -- Over SSH: no desktop session, so skip all D-Bus/gsettings calls.
    -- Instead rely on Neovim's own OSC 11 terminal query (vim.o.background),
    -- which travels transparently through the SSH connection to the local terminal.
    if is_ssh() then
        return vim.o.background == 'light'
    end

    -- 1. XDG Desktop Portal (works on both GNOME and Hyprland with xdg-desktop-portal)
    --    Returns: 0 = no preference, 1 = prefer dark, 2 = prefer light
    --    Checked first because it always reflects the live desktop state.
    --    TERM_BACKGROUND is set once at login and can be stale after a theme switch.
    local portal = vim.fn.system(
        'gdbus call --session --dest org.freedesktop.portal.Desktop'
            .. ' --object-path /org/freedesktop/portal/desktop'
            .. ' --method org.freedesktop.portal.Settings.Read'
            .. ' org.freedesktop.appearance color-scheme 2>/dev/null'
    )
    local scheme = portal:match 'uint32 (%d+)'
    if scheme == '1' then
        return false
    elseif scheme == '2' then
        return true
    end

    -- 2. TERM_BACKGROUND env var (kitty, WezTerm — set dynamically per window by those terminals)
    local term_bg = os.getenv 'TERM_BACKGROUND'
    if term_bg then
        return term_bg == 'light'
    end

    -- 3. GTK_THEME env var (commonly set on Hyprland)
    local gtk_theme_env = os.getenv 'GTK_THEME'
    if gtk_theme_env then
        return not gtk_theme_env:lower():match 'dark'
    end

    -- 4. GTK settings.ini files (standard on Hyprland and other non-GNOME desktops)
    local home = os.getenv 'HOME' or ''
    for _, ini in ipairs { home .. '/.config/gtk-4.0/settings.ini', home .. '/.config/gtk-3.0/settings.ini' } do
        local content = read_file(ini)
        if content then
            local dark = gtk_ini_is_dark(content)
            if dark ~= nil then
                return not dark
            end
        end
    end

    -- 5. GNOME gsettings color-scheme (GNOME only)
    local result = vim.fn.system 'gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null'
    if result:match 'prefer%-light' then
        return true
    elseif result:match 'prefer%-dark' then
        return false
    end

    -- 6. GNOME GTK theme name: absence of 'dark' implies light
    local gtk_theme = vim.fn.system 'gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null'
    if gtk_theme and gtk_theme ~= '' then
        return not gtk_theme:lower():match 'dark'
    end

    return false
end

function M.apply()
    if is_light() then
        pcall(vim.cmd.colorscheme, 'intellij_light')
    else
        vim.o.background = 'dark'
        pcall(vim.cmd.colorscheme, 'onedark')
    end
end

return M
