return {

	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function(_, opts)
			local dap = require("dap")
			if opts.configurations ~= nil then
				local dapConfigs = vim.tbl_deep_extend("force", dap.configurations, opts.configurations)
				dap.configurations = dapConfigs
				local dapAdapters = vim.tbl_deep_extend("force", dap.adapters, opts.adapters)
				dap.adapters = dapAdapters
			end
		end,

		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle [d]ebug [b]reakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[d]ebug [c]ontinue",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "[d]ebug step [o]ver",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "[d]debug step [i]n",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "[d]ebug step [O]ut",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "[d]ebug [t]erminate",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "[d]ebug [u]i",
			},
			{
				"<leader>td",
				function()
					-- vim.cmd("Neotree close")
					require("neotest").summary.close()
					require("neotest").output_panel.close()
					require("neotest").run.run({ suite = false, strategy = "dap" })
				end,
				desc = "Nearest [t]est [d]ebug",
			},
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap",
		},
		opts = {},
		config = function(_, opts)
			-- setup dap config by VsCode launch.json file
			-- require("dap.ext.vscode").load_launchjs()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
}
