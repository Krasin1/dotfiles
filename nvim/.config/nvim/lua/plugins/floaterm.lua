return {
    {
        "voldikss/vim-floaterm",
        config = function()
            local g = vim.g

            -- g.floaterm_keymap_toggle = '<F1>'
            vim.api.nvim_set_keymap('n', '<F1>', ":FloatermToggle<cr>", { desc = "Terminal Toggle", silent = true, noremap = true })
            vim.api.nvim_set_keymap('t', '<F1>', "<C-\\><C-n>:FloatermToggle<cr>", { desc = "Terminal Toggle", silent = true, noremap = true })
            -- g.floaterm_keymap_prev = '<F2>'
            vim.api.nvim_set_keymap('n', '<F2>', ":FloatermPrev<cr>", { desc = "Terminal Previous", silent = true, noremap = true })
            vim.api.nvim_set_keymap('t', '<F2>', "<C-\\><C-n>:FloatermPrev<cr>", { desc = "Terminal Previous", silent = true, noremap = true })
            -- g.floaterm_keymap_next = '<F3>'
            vim.api.nvim_set_keymap('n', '<F3>', ":FloatermNext<cr>", { desc = "Terminal Next", silent = true, noremap = true })
            vim.api.nvim_set_keymap('t', '<F3>', "<C-\\><C-n>:FloatermNext<cr>", { desc = "Terminal Next", silent = true, noremap = true })
            -- g.floaterm_keymap_new = '<F4>'
            vim.api.nvim_set_keymap('n', '<F4>', ":FloatermNew<cr>", { desc = "Terminal New", silent = true, noremap = true })
            vim.api.nvim_set_keymap('t', '<F4>', "<C-\\><C-n>:FloatermNew<cr>", { desc = "Terminal New", silent = true, noremap = true })

            g.floaterm_gitcommit = "floaterm"
            g.floaterm_autoinsert = 1
            g.floaterm_width = 0.8
            g.floaterm_height = 0.8
            g.floaterm_wintitle = 0
            g.floaterm_autoclose = 1

            vim.api.nvim_set_keymap('n', '<Leader>tt', ":FloatermToggle<cr>", { desc = "Terminal Toggle", silent = true, noremap = true })
            vim.api.nvim_set_keymap('n', '<Leader>tp', ":FloatermNew python<cr>", { desc = "Terminal Python", silent = true, noremap = true })

        end
    }
}
