-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Hyprland configuration (Lua)                                ║
-- ║  Hyprland 0.57+ no longer reads legacy *.conf files.         ║
-- ║  The old .conf files were migrated to Lua and removed.       ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- See https://wiki.hypr.land/configuring/

local home       = os.getenv("HOME")
local configHome = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local hyprDir    = configHome .. "/hypr"
local scrPath    = home .. "/.local/share/bin"

local function include(name)
    dofile(hyprDir .. "/" .. name .. ".lua")
end

-- █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
-- █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄

include("theme")
include("animations")
include("monitors")
include("nvidia")
include("keybindings")
include("windowrules")

-- █░░ ▄▀█ █░█ █▀█ █▀█ ▀█▀ █▀
-- █▄▄ █▀█ █▄█ █▀▄ █▀▄ ░█░ ▄█

hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/dotfiles/scripts/resetxdgportal.sh") -- reset XDPH for screenshare
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd("dbus-update-activation-environment --systemd --all") -- for XDPH
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &") -- authentication dialogue for GUI apps
    hl.exec_cmd("blueman-applet") -- systray app for Bluetooth
    hl.exec_cmd("udiskie --tray") -- front-end that allows to manage removable media
    hl.exec_cmd("nm-applet --indicator") -- systray app for Network/Wifi
    hl.exec_cmd("dunst") -- start notification demon
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- clipboard store text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- clipboard store image data
    hl.exec_cmd([[rm "$HOME/.cache/cliphist/db"]])
    hl.exec_cmd("swaybg -i " .. home .. "/Wallpapers/everlasting_summer_1.jpg")
    -- hl.exec_cmd(scrPath .. "/batterynotify.sh") -- battery notification

    hl.dispatch(hl.dsp.focus({ workspace = 1 })) -- set the first workspace at start
    hl.exec_cmd(home .. "/.config/eww/launch_bar") -- eww bar
    hl.exec_cmd("/opt/v2rayn-bin/v2rayN")

    -- NOTE: if laptop : enable gestures + bind right ctrl to windows key
    hl.exec_cmd([[if grep -q -i "touchpad\|synaptics" /proc/bus/input/devices; then
        libinput-gestures &
        hyprctl keyword input:kb_options "grp:caps_toggle,ctrl:swap_rwin_rctl"
    fi]])

    -- NOTE: If found nvidia - this is PC, else laptop
    hl.exec_cmd([[if command -v nvidia-smi >/dev/null 2>&1; then
        sudo -E env WAYLAND_DISPLAY="$WAYLAND_DISPLAY" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" QT_QPA_PLATFORM=wayland nvidia-settings \
            -a "[gpu:0]/GPUFanControlState=1" \
            -a "[fan:0]/GPUTargetFanSpeed=60" \
            -a "[fan:1]/GPUTargetFanSpeed=60"
    fi]])
end)

-- █▀▀ █▄░█ █░█
-- ██▄ █░▀█ ▀▄▀

hl.env("PATH", (os.getenv("PATH") or "") .. ":" .. scrPath)

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("XDG_ICON_THEME", "Qogir")

hl.env("SSH_AUTH_SOCK", (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") .. "/ssh-agent.socket")

-- █ █▄░█ █▀█ █░█ ▀█▀
-- █ █░▀█ █▀▀ █▄█ ░█░

hl.config({
    input = {
        kb_layout    = "us,ru",
        kb_options   = "grp:caps_toggle",
        follow_mouse = 1,
        repeat_delay = 250,
        repeat_rate  = 70,

        touchpad = {
            disable_while_typing = false,
            natural_scroll       = true,
        },

        sensitivity       = 0,
        accel_profile     = "flat",
        numlock_by_default = true,
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- gestures {
--     workspace_swipe = true
--     workspace_swipe_fingers = 3
-- }

-- █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
-- █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█

-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/
-- hl.config({
--     dwindle = {
--         pseudotile    = true,
--         preserve_split = true,
--     },
-- })

-- See https://wiki.hypr.land/configuring/layouts/master-layout/
hl.config({
    master = {
        new_status = "master",
    },
})

-- █▀▄▀█ █ █▀ █▀▀
-- █░▀░█ █ ▄█ █▄▄

hl.config({
    misc = {
        vrr                    = 0,
        disable_hyprland_logo  = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
})

hl.config({
    ecosystem = {
        no_update_news = true,
    },
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-- █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █▀▀ █▀▀ █▀
-- █▄█ ▄█ ██▄ █▀▄   █▀▀ █▀▄ ██▄ █▀░ ▄█

include("userprefs")
