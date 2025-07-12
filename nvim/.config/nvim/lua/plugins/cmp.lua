return {
	{
		"Exafunction/codeium.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"FelipeLema/cmp-async-path",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local lspkind = require("lspkind")
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				mapping = {
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = function()
						if cmp.visible() then
							cmp.close()
						else
							cmp.complete({})
						end
					end,
					--[[ ["<C-Space>"] = cmp.mapping.complete(), ]]
					--[[ ["<C-e>"] = cmp.mapping.close(), ]]
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "codeium" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "async_path" },
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format({
						menu = {
							codeium = "[AI]",
							luasnip = "[Snip]",
							nvim_lsp = "[LSP]",
							buffer = "[Buf]",
							async_path = "[Path]",
						},
						symbol_map = { Codeium = "" },
					}),
				},
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
				formatting = {
					format = lspkind.cmp_format({
						menu = {
							buffer = "[Buf]",
						},
					}),
				},
			})
			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "async_path" },
				}, {
					{ name = "cmdline" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						menu = {
							async_path = "[Path]",
							cmdline = "[Cmd]",
						},
					}),
				},
			})
		end,
	},
}
