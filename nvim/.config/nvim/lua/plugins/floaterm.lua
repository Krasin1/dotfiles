return {
    {
        "voldikss/vim-floaterm",
        config = function()
            local g = vim.g

            g.floaterm_gitcommit = "floaterm"
            g.floaterm_autoinsert = 1
            g.floaterm_width = 0.8
            g.floaterm_height = 0.8
            g.floaterm_wintitle = 0
            g.floaterm_autoclose = 1

        end
    }
}
