return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"RRethy/nvim-treesitter-endwise",
	},
	lazy = false,
	branch = "main",
	build = { ":TSUpdate" },
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local filetype = args.match
				local lang = vim.treesitter.language.get_lang(filetype)
				if vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
					require("nvim-treesitter").install(lang):await(function()
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.treesitter.start()
					end)
				end
			end,
		})
	end,
}

-- return {
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		dependencies = {
-- 			"RRethy/nvim-treesitter-endwise",
-- 		},
--         branch = 'main',
-- 		build = ":TSUpdate",
-- 		config = function()
-- 			require("nvim-treesitter.configs").setup({
-- 				ensure_installed = "all",
-- 				highlight = {
-- 					enable = true,
-- 					additional_vim_regex_highlighting = false,
-- 				},
-- 				indent = {
-- 					enable = true,
-- 				},
-- 				endwise = {
-- 					enable = true,
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
