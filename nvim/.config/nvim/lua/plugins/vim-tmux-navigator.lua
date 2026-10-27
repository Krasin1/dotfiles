return {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
        -- Must be set before the plugin loads: it checks this flag while
        -- sourcing plugin/tmux_navigator.vim (config() would be too late).
        vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
        local nav = {
            { '<C-S-h>', 'TmuxNavigateLeft', 'Navigate left' },
            { '<C-S-j>', 'TmuxNavigateDown', 'Navigate down' },
            { '<C-S-k>', 'TmuxNavigateUp', 'Navigate up' },
            { '<C-S-l>', 'TmuxNavigateRight', 'Navigate right' },
            -- { '<M-\\>', 'TmuxNavigatePrevious', 'Previous pane' },
        }
        for _, m in ipairs(nav) do
            vim.keymap.set('n', m[1], ':<C-U>' .. m[2] .. '<cr>', { silent = true, desc = m[3] })
            -- terminal: same trick as upstream (<C-w>: keeps terminal-mode)
            vim.keymap.set('t', m[1], '<C-w>:<C-U>' .. m[2] .. '<cr>', { silent = true, desc = m[3] })
        end
    end,
}
