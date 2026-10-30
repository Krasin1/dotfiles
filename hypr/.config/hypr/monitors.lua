-- █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█ █▀
-- █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄ ▄█
--
-- See https://wiki.hypr.land/configuring/core/monitors/

hl.monitor({ output = "HDMI-A-2", disabled = true })
hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@170",
    position = "0x0",
    scale    = 1,
    vrr      = 1,
})
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@60",
    position = "2560x0",
    scale    = 1,
})

-- Bind workspaces to monitors and keep them alive
hl.workspace_rule({ workspace = "2", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "1", monitor = "DP-2", persistent = true })

-- workspace = 1, monitor:DP-1, persistent:true
-- workspace = 2, monitor:DP-1, persistent:true
-- workspace = 3, monitor:DP-1, persistent:true
-- workspace = 4, monitor:DP-1, persistent:true
-- workspace = 5, monitor:DP-1, persistent:true
--
-- workspace = 6, monitor:DP-2, persistent:true
-- workspace = 7, monitor:DP-2, persistent:true
-- workspace = 8, monitor:DP-2, persistent:true
-- workspace = 9, monitor:DP-2, persistent:true
-- workspace = 10, monitor:DP-2, persistent:true
--
-- workspace = 1-5, monitor:l
-- workspace = 6-10, monitor:r
