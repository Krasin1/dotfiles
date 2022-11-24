local navic = require("nvim-navic")

require('lualine').setup {
    options = {
        theme = 'tokyonight',
    },
    sections = {
        lualine_c = { { navic.get_location, cond = navic.is_available } },
    },
    tabline = {
        lualine_a = { {
            'buffers',
            mode = 2,
            buffers_color = {
                active = function(section) return { bg = vim.bo.modified and '#ebe834' or "#7aa2f7" } end,
            },
        } },
    },
}

-- jump to buffer
-- vim.api.nvim_set_keymap('n', (vim.v.count)'<TAB>', ':LualineBuffersJump! (vim.v.count)<CR>', { silent = true, noremap = true })
