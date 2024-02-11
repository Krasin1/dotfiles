return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local map = vim.api.nvim_set_keymap

            map('n', '<Leader>ff', ":lua require('telescope.builtin').find_files()<cr>", { desc = "Find files", silent = true, noremap = true })
            map('n', '<Leader>fg', ":lua require('telescope.builtin').live_grep()<cr>", { desc = "Find Grep", silent = true, noremap = true })
            map('n', '<Leader>fb', ":lua require('telescope.builtin').buffers()<cr>", { desc = "Find Buffers", silent = true, noremap = true })
            map('n', '<Leader>fh', ":lua require('telescope.builtin').help_tags()<cr>", { desc = "Find Help", silent = true, noremap = true })

            require('telescope').setup{
                defaults = {
                    mappings = {
                        i = {
                            -- map actions.which_key to <C-h> (default: <C-/>)
                            -- actions.which_key shows the mappings for your picker,
                            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                            ["<C-h>"] = "which_key"
                        }
                    }
                },
                pickers = {},
                extensions = {},
            }
            require("telescope").load_extension("noice")
        end
    },
	{
		"nvim-telescope/telescope-ui-select.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
