return {
	"mason-org/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
	},
	config = function()
		-- mason lspconfig
		require("mason-lspconfig").setup({
			-- automatic_enable = true,
			automatic_enable = {
                exclude = {
                    "lua_ls",
                    "ts_ls",
                    "eslint",
                    "emmet_ls",
                    "biome",
			        "cssls",
                }
            },
		})

		-- lsp servers
		local servers = {
			-- lua_ls
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
								"Snacks",
								"require",
							},
						},
					},
				},
			},
            rust_analyzer = {
                completion = {
                    callable = {
                        snippets = 'add_parenthesis'
                    },
                },
            },
			-- ts_ls
			ts_ls = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
                    "vue",
				},
				init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            -- location = require('mason-registry').get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server',
                            -- location = "", -- Set this to the plugin path if not automatically found
                            location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                            languages = { "vue" },
                            configNamespace = 'typescript',
                        }
                    },
					preferences = {
						disableSuggestions = true,
					},
				},
			},
			-- eslint
			eslint = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			},
			-- biome
			biome = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			},
			-- emmet_ls
			emmet_ls = {
				filetypes = {
					"html",
					"htmx",
					"typescriptreact",
					"javascriptreact",
				},
			},
			-- cssls
			cssls = {
				settings = {
					css = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
					scss = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
					less = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
				},
			},
			-- clangd
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--clang-tidy-checks=-*,-clang-analyzer-*,performance-*,bugprone-*,qt-*,clazy-*",
				},
			},
		}

		-- enable lsps
		for server, config in pairs(servers) do
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}

