return require('packer').startup(function(use)

    -- Theme
    use 'folke/tokyonight.nvim'

    -- Statusline
    use 'nvim-lualine/lualine.nvim'

    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- Leap
    use 'ggandor/leap.nvim'

    -- Quickscope
    use 'unblevable/quick-scope'

    -- Ranger
    use 'kevinhwang91/rnvimr'

    -- Floaterm
    use 'voldikss/vim-floaterm'

    -- Indent line
    use 'lukas-reineke/indent-blankline.nvim'

    -- Colorizer
    use 'norcalli/nvim-colorizer.lua'

    -- LSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use 'onsails/lspkind-nvim'
    use 'tami5/lspsaga.nvim' -- Subject to change
    use 'SmiteshP/nvim-navic'

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    -- use 'L3MON4D3/LuaSnip'
    -- use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lsp'
    -- use 'hrsh7th/cmp-nvim-lua'



    -- -- Markdown editing
    -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    --     setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    --     ft = { "markdown" }, })

    -- Copilot
    -- use 'github/copilot.vim'

    -- Comment
    use "terrortylor/nvim-comment"

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Devicons
    use 'kyazdani42/nvim-web-devicons'

end)
