-- █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
-- ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█
--
-- See https://wiki.hypr.land/configuring/core/rules/window-rules/

-- Opacity
local function opacityRule(class, active, inactive)
    hl.window_rule({
        match   = { class = "^(" .. class .. ")$" },
        opacity = active .. " " .. inactive,
    })
end

for _, class in ipairs({
    "firefox",
    "Google-chrome",
    "Brave-browser",
    "com.github.rafostar.Clapper", -- Clapper-Gtk
}) do
    opacityRule(class, "0.90", "0.90")
end

for _, class in ipairs({
    "code-oss",
    "[Cc]ode",
    "code-url-handler",
    "code-insiders-url-handler",
    "org.kde.dolphin",
    "org.kde.ark",
    "nwg-look",
    "qt5ct",
    "qt6ct",
    "kvantummanager",
    "com.github.tchx84.Flatseal",       -- Flatseal-Gtk
    "hu.kramo.Cartridges",              -- Cartridges-Gtk
    "com.obsproject.Studio",            -- Obs-Qt
    "gnome-boxes",                      -- Boxes-Gtk
    "vesktop",                          -- Vesktop
    "discord",                          -- Discord-Electron
    "WebCord",                          -- WebCord-Electron
    "ArmCord",                          -- ArmCord-Electron
    "app.drey.Warp",                    -- Warp-Gtk
    "net.davidotek.pupgui2",            -- ProtonUp-Qt
    "yad",                              -- Protontricks-Gtk
    "Signal",                           -- Signal-Gtk
    "io.github.alainm23.planify",       -- planify-Gtk
    "io.gitlab.theevilskeleton.Upscaler", -- Upscaler-Gtk
    "com.github.unrud.VideoDownloader", -- VideoDownloader-Gtk
    "io.gitlab.adhami3310.Impression",  -- Impression-Gtk
    "io.missioncenter.MissionCenter",   -- MissionCenter-Gtk
    "io.github.flattool.Warehouse",     -- Warehouse-Gtk
}) do
    opacityRule(class, "0.80", "0.80")
end

for _, class in ipairs({
    "org.pulseaudio.pavucontrol",
    "blueman-manager",
    "nm-applet",
    "nm-connection-editor",
    "org.kde.polkit-kde-authentication-agent-1",
    "polkit-gnome-authentication-agent-1",
    "org.freedesktop.impl.portal.desktop.gtk",
    "org.freedesktop.impl.portal.desktop.hyprland",
}) do
    opacityRule(class, "0.80", "0.70")
end

for _, class in ipairs({
    "[Ss]team",
    "steamwebhelper",
    "[Ss]potify",
}) do
    opacityRule(class, "0.70", "0.70")
end

hl.window_rule({ match = { initial_title = "^(Spotify Free)$" },    opacity = "0.70 0.70" })
hl.window_rule({ match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70" })

-- Floating windows
local floatTitles = {
    { class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" },
    { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" },
    { title = "^(About Mozilla Firefox)$" },
    { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
    { class = "^(firefox)$", title = "^(Library)$" },
    { class = "^(kitty)$",   title = "^(top)$" },
    { class = "^(kitty)$",   title = "^(btop)$" },
    { class = "^(kitty)$",   title = "^(htop)$" },
}

for _, match in ipairs(floatTitles) do
    hl.window_rule({ match = match, float = true })
end

for _, class in ipairs({
    "vlc",
    "kvantummanager",
    "qt5ct",
    "qt6ct",
    "nwg-look",
    "org.kde.ark",
    "org.pulseaudio.pavucontrol",
    "blueman-manager",
    "nm-applet",
    "nm-connection-editor",
    "org.kde.polkit-kde-authentication-agent-1",
    "Signal",                            -- Signal-Gtk
    "com.github.rafostar.Clapper",       -- Clapper-Gtk
    "app.drey.Warp",                     -- Warp-Gtk
    "net.davidotek.pupgui2",             -- ProtonUp-Qt
    "yad",                               -- Protontricks-Gtk
    "eog",                               -- Imageviewer-Gtk
    "io.github.alainm23.planify",        -- planify-Gtk
    "io.gitlab.theevilskeleton.Upscaler", -- Upscaler-Gtk
    "com.github.unrud.VideoDownloader",  -- VideoDownloader-Gtk
    "io.gitlab.adhami3310.Impression",   -- Impression-Gtk
    "io.missioncenter.MissionCenter",    -- MissionCenter-Gtk
}) do
    hl.window_rule({ match = { class = "^(" .. class .. ")$" }, float = true })
end

-- common modals
-- hl.window_rule({ match = { title = "^(Open)$" }, float = true })
-- hl.window_rule({ match = { title = "^(Choose Files)$" }, float = true })
-- hl.window_rule({ match = { title = "^(Save As)$" }, float = true })
-- hl.window_rule({ match = { title = "^(Confirm to replace files)$" }, float = true })
-- hl.window_rule({ match = { title = "^(File Operation Progress)$" }, float = true })
-- hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })

--
-- My adds
--

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    move  = { "monitor_w * 0.13", "monitor_h * 0.05" },
})
