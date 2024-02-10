return {
    {
        "unblevable/quick-scope",
        -- lazy = false,
        init = function()
            vim.g.qs_highlight_on_keys = { 'f', 'F' }
            vim.g.qs_max_chars=250
            
            vim.cmd([[
                augroup qs_colors
                  autocmd!
                  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
                  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
                augroup END
            ]])
        end,
    }
}
