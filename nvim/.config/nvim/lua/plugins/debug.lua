return {
	-- {
	-- 	"jay-babu/mason-nvim-dap.nvim",
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 	},
	-- 	opts = {
	-- 		ensure_installed = { "codelldb" },
	-- 		automatic_installation = true,
	-- 		handlers = {},
	-- 	},
	-- 	-- config = function()
	-- 	-- require("mason-nvim-dap").setup({})
	-- 	-- end,
	-- },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
		},
		config = function()
			local dapui = require("dapui")
			local dap = require("dap")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			--
			-- dap.adapters.codelldb = {
			-- 	type = "server",
			-- 	port = "${port}",
			-- 	executable = {
			-- 		-- CHANGE THIS to your path!
			-- 		command = "/home/conf/.local/share/mason/bin/codelldb",
			-- 		args = { "--port", "${port}" },
			--
			-- 		-- On windows you may have to uncomment this:
			-- 		-- detached = false,
			-- 	},
			-- }
			-- dap.configurations.cpp = {
			-- 	{
			-- 		name = "Launch file",
			-- 		type = "codelldb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 	},
			-- }
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "-i", "dap" },
			}
			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

		end,
	},
}
