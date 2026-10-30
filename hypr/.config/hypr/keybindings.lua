-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█
--
-- See https://wiki.hypr.land/configuring/core/binds/
--  &  https://wiki.hypr.land/configuring/core/dispatchers/

local home = os.getenv("HOME")

-- Main modifier
local mainMod = "SUPER" -- super / meta / windows key

-- Assign apps
local terminal    = "alacritty"
local editor      = "neovim"
local fileManager = "nemo"
local browser     = "firefox"

-- Window/Session actions
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Color Picker" }) -- Pick color (Hex) >> clipboard
hl.bind(mainMod .. " + Q", hl.dsp.window.close())               -- close focused window
hl.bind("ALT + F4", hl.dsp.window.close())                      -- close focused window
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exit())                 -- kill hyprland session
hl.bind(mainMod .. " + T", hl.dsp.window.float())               -- toggle the window between focus and float
hl.bind("ALT + Return", hl.dsp.window.fullscreen())             -- toggle the window between focus and fullscreen
-- hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd(home .. "/.local/share/bin/logoutlaunch.sh")) -- launch logout menu
hl.bind("CTRL + ALT + E", hl.dsp.exec_cmd(home .. "/.config/eww/launch_bar")) -- reload eww bar

-- Application shortcuts
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))       -- launch terminal emulator
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))         -- launch file manager
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))              -- launch text editor
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))             -- launch web browser
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("kitty -- btop")) -- launch system monitor (btop)

-- Rofi menus
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("pkill -x rofi || rofi -show combi"))  -- launch application launcher
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("pkill -x rofi || rofi -show window"))   -- launch window switcher

-- Audio control
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/mic_mute"), { locked = true })                 -- toggle microphone mute
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/volume mute"), { locked = true })                 -- toggle audio mute
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/volume down"), { locked = true, repeating = true }) -- decrease volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/volume up"), { locked = true, repeating = true })   -- increase volume

-- Media control
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })  -- toggle between media play and pause
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- toggle between media play and pause
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })        -- media next
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })    -- media previous
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })        -- media stop

-- Brightness control
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/brightness.sh up"), { locked = true, repeating = true })   -- increase brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/brightness.sh down"), { locked = true, repeating = true }) -- decrease brightness

-- Move between grouped windows
-- hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.active({ index = -1 }))
-- hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.active({ index = 1 }))

-- Screenshot/Screencapture
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/screenshot.sh s"))            -- partial screenshot capture
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/screenshot.sh sf"))      -- partial screenshot capture (frozen screen)
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/screenshot.sh m"))        -- monitor screenshot capture
hl.bind("Print", hl.dsp.exec_cmd(home .. "/dotfiles/scripts/screenshot.sh p"))                        -- all monitors screenshot capture

-- Move/Change window focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Switch workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    -- Move focused window to a workspace silently
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Switch workspaces to a relative workspace
hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ workspace = "r-1" }))

-- Move to the first empty workspace
hl.bind(mainMod .. " + CTRL + J", hl.dsp.focus({ workspace = "empty" }))
-- Move to the last used workspace
hl.bind(mainMod .. " + CTRL + K", hl.dsp.focus({ workspace = "previous" }))

-- Resize windows
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Move focused window to a relative workspace
hl.bind(mainMod .. " + CTRL + ALT + L", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + H", hl.dsp.window.move({ workspace = "r-1" }))

-- Move active window around current workspace with mainMod + Shift + hjkl
local function moveActiveWindow(dx, dy, direction)
    return function()
        local window = hl.get_active_window()
        if window and window.floating then
            hl.dispatch(hl.dsp.window.move({ x = dx, y = dy, relative = true }))
        else
            hl.dispatch(hl.dsp.window.move({ direction = direction }))
        end
    end
end

hl.bind(mainMod .. " + SHIFT + H", moveActiveWindow(-30, 0, "left"), { description = "Move activewindow left" })
hl.bind(mainMod .. " + SHIFT + L", moveActiveWindow(30, 0, "right"), { description = "Move activewindow right" })
hl.bind(mainMod .. " + SHIFT + K", moveActiveWindow(0, -30, "up"), { description = "Move activewindow up" })
hl.bind(mainMod .. " + SHIFT + J", moveActiveWindow(0, 30, "down"), { description = "Move activewindow down" })

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/Resize focused window
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

-- Move/Switch to special workspace (scratchpad)
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))

-- Toggle focused window split
-- hl.bind(mainMod .. " + U", hl.dsp.layout("togglesplit"))

-- Make windows in current workspace equal
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd([==[hyprctl -j clients | jq -r --argjson ws "$(hyprctl -j activeworkspace | jq .id)" '.[] | select(.workspace.id == $ws) | .address' | xargs -I{} sh -c 'hyprctl dispatch focuswindow address:{}; hyprctl dispatch splitratio exact 1']==]))
