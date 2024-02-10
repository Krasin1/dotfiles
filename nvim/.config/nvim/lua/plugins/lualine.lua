return {
    {
        "SmiteshP/nvim-navic",
        dependencies = {"neovim/nvim-lspconfig"},
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"SmiteshP/nvim-navic"},
        config = function()
            local navic = require("nvim-navic")

            require('lualine').setup {
                options = {
                    theme = 'tokyonight',
                },
                sections = {
                    -- lualine_c = { { navic.get_location, cond = navic.is_available } },
                    lualine_c = { { function() return navic.get_location() end, cond = navic.is_available } },
                },
                tabline = {
                    lualine_a = { {
                        'buffers',
                        mode = 2,
                        buffers_color = {
                            active = function() return { bg = vim.bo.modified and '#ebe834' or "#7aa2f7" } end,
                        },
                    } },
                },
            }
            -- jump to buffer
            -- vim.api.nvim_set_keymap('n', (vim.v.count)'<TAB>', ':LualineBuffersJump! (vim.v.count)<CR>', { silent = true, noremap = true })
        end
    }
}
