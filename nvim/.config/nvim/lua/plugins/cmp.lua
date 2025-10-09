return {
    {
		"saghen/blink.cmp",
		dependencies = {
			{ "xzbdmw/colorful-menu.nvim", opts = {} },
			{ "Exafunction/codeium.nvim", opts = { enable_cmp_source = false } },
		},

		event = { "InsertEnter", "CmdlineEnter" },
		version = "1.*",
		opts = {
			keymap = {

				preset = "enter",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<A-space>"] = { "cancel", "fallback" },
				["<CR>"] = { "accept", "fallback" },

				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },

				["<A-k>"] = { "select_prev", "fallback" },
				["<A-j>"] = { "select_next", "fallback" },

				["<C-j>"] = { "snippet_forward", "scroll_documentation_down", "fallback" },
				["<C-k>"] = { "snippet_backward", "scroll_documentation_up", "fallback" },

				["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "bold",
					},
				},
				menu = {
					max_height = 13,
					border = "bold",
					scrollbar = false,
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", "label", gap = 2 },
							{ "kind", "source_id", gap = 1 },
						},
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
							source_id = {
								width = { max = 30 },
								text = function(ctx)
									local source_map = {
										lsp = "[LSP]",
										snippets = "[Snip]",
										buffer = "[Buf]",
										path = "[Path]",
										codeium = "[AI]",
                                        cmdline = "[Cmd]",
									}
									return source_map[ctx.source_id] or string.format("[%s]", ctx.source_id)
								end,
								highlight = "BlinkCmpLabel",
							},
						},
					},
				},
				ghost_text = {
					enabled = false,
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "codeium", "lsp", "path", "snippets", "buffer" },
				providers = {
					codeium = { name = "Codeium", module = "codeium.blink", async = true },
					path = { opts = { show_hidden_files_by_default = true } },
				},
			},
			signature = {
				enabled = true,
			},
			cmdline = {
				keymap = {
					preset = "inherit",
					["<CR>"] = {},
				},
				enabled = true,
				sources = { "buffer", "cmdline", "path" },
				completion = {
					menu = { auto_show = true },
					list = {
						selection = {
							preselect = false,
							auto_insert = true,
						},
					},
				},
			},
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "2.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip").setup({ enable_autosnippets = true })
			require("luasnip.loaders.from_vscode").lazy_load()
			-- require("luasnip.loaders.from_lua").load({
			-- paths = { "./lua/grimmvim/plugins/lsp_completion/snippets" },
			-- })
		end,
	},
}
