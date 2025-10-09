return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua =       { "stylua" },
            rust =      { "rustfmt" },
			c =         { "clang_format" },
			cpp =       { "clang_format" },
			python =    { "isort", "black" },
			javascript = { "prettier" },
			css =       { "prettier" },
			html =      { "prettier" },
            yaml =      { "prettier" },
            markdown =  { "prettier" },
            json =      { "prettier" },
			sh =        { "beautysh" },
		},
		-- format_on_save = { timeout_ms = 500 },
	},
	keys = {
		{
			mode = { "n", "v" },
			"<leader>F",
			function()
				require("conform").format({
					lsp_fallback = true,
				})
			end,
			desc = "Format file",
		},
	},
}
