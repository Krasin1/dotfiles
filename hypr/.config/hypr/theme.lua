-- █░░ █▀█ █▀█ █▄▀   ▄▀█ █▄░█ █▀▄   █▀▀ █▀▀ █▀▀ █░░
-- █▄▄ █▄█ █▄█ █░█   █▀█ █░▀█ █▄▀   █▀░ ██▄ ██▄ █▄▄
--
-- See https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = { top = 1, right = 10, bottom = 15, left = 10 },
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 10,

        shadow = {
            enabled = false,
        },

        -- Change transparency of focused and unfocused windows
        -- active_opacity   = 1
        -- inactive_opacity = 1

        dim_special = 0.3,

        blur = {
            enabled           = true,
            size              = 5,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
            special           = true,
        },
    },
})
