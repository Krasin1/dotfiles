return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        name = "tokyonight",
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                on_colors = function(colors)
                    colors.bg_visual = "#275378"
                end
            })
            vim.cmd.colorscheme "tokyonight-night"
        end
    }
}
