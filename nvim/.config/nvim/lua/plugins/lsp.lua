local signature_opts = {
	bind = true,
	hint_enable = false,
	max_height = 8,
	floating_window_off_y = -1,
	handler_opts = {
		border = "rounded",
	},
}

local on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
	require("lsp_signature").on_attach(signature_opts, bufnr)

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- local function buf_set_option(...)
	-- 	vim.api.nvim_buf_set_option(bufnr, ...)
	-- end

	-- Enable completion triggered by <c-x><c-o>
	-- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Mappings.
	local opts = { noremap = true, silent = true }
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

	buf_set_keymap("n", "\\wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "\\wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "\\wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

	buf_set_keymap("n", "\\D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

	buf_set_keymap("n", "\\q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

	-- Lspsaga mappings
	-- local map = vim.api.nvim_set_keymap
	buf_set_keymap("n", "\\rn", "<cmd>Lspsaga rename<cr>", opts)
	buf_set_keymap("n", "\\ca", "<cmd>Lspsaga code_action<cr>", opts)
	buf_set_keymap("x", "\\ca", "<c-u>Lspsaga range_code_action<cr>", opts)
	buf_set_keymap("n", "\\gh", "<cmd>Lspsaga finder<cr>", opts)
	buf_set_keymap("n", "\\pd", "<cmd>Lspsaga peek_definition<cr>", opts)
	buf_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
	buf_set_keymap("n", "\\l", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
	buf_set_keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
	buf_set_keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
end

return {
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				-- code_action = { num_shortcut = false },
				symbol_in_winbar = { enable = false },
				outline = { enable = false },
				implement = { enable = false },
				callhierarchy = { enable = false },
				-- finder = { enable = false },
				-- definition = { },
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "pyright", "lua_ls", "rust_analyzer", "ts_ls", "jdtls", "bashls" },
			})
			require("mason-tool-installer").setup({
				ensure_installed = { "clang-format", "stylua", "prettier", "black", "isort", "beautysh" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvimdev/lspsaga.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("lspconfig").lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- -- Setup your lua path
							-- path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})
			require("lspconfig").pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			require("lspconfig").clangd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			require("lspconfig").rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			require("lspconfig").jdtls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			require("lspconfig").ts_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			require("lspconfig").bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = signature_opts,
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
}
