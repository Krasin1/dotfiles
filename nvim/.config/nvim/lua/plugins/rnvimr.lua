return {
    {
        "kevinhwang91/rnvimr",
        config = function()
            local g = vim.g

            g.rnvimr_enable_ex = 1
            g.rnvimr_enable_bw = 1

            vim.api.nvim_set_keymap('n', '<Leader>r', ":RnvimrToggle<cr>", { desc = "Ranger", silent = true, noremap = true })
        end
    }
}
