return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = {
        fzf_opts = {
            [ '--cycle' ] = true,
        },
        keymap = {
            fzf = {
                [ "Tab" ] = "down",
                [ "shift-Tab" ] = "up",
            }
        }
    },
    keys = {
        {
            "<leader>ff",
            function() require('fzf-lua').files() end,
            desc = "Find files"
        },
        {
            "<leader>fg",
            function() require('fzf-lua').live_grep() end,
            desc = "Find Grep"
        },
        {
            "<leader>fb",
            function() require('fzf-lua').buffers() end,
            desc = "Find Buffers"
        },
        {
            "<leader>fh",
            function() require('fzf-lua').help_tags() end,
            desc = "Find Help"
        },
        {
            "<leader>fr",
            function() require('fzf-lua').oldfiles() end,
            desc = "Open recent files"
        },
        {
            "<leader>fk",
            function() require('fzf-lua').keymaps() end,
            desc = "[F]ind [K]eymaps"
        }
    },
}
