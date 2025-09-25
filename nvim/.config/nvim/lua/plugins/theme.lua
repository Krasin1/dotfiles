return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        name = "tokyonight",
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                transparent = true,
                styles = {
                    floats = "transparent",
                    sidebars = "transparent"
                },
                on_highlights = function (highlights, _)
                    highlights.LspSignatureActiveParameter.bg = "#275378"
                end,
            })
            vim.cmd.colorscheme "tokyonight-night"
        end
    }
}
