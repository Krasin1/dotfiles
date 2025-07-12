return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"\\f",
				function()
					require("conform").format({ async = true })
				end,
				desc = "Format file",
			},
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				python = { "isort", "black" },
				javascript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				rust = { "rustfmt" },
				sh = { "beautysh" },
			},
			default_format_opts = {
				lsp_fallback = true,
			},
			-- format_on_save = { timeout_ms = 500 },
		},
	},
}
