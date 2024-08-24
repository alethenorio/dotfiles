return {
	"nvim-neo-tree/neo-tree.nvim",
	-- branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		follow_current_file = {
			enabled = true,
		},
		use_default_mappings = false,
		window = {
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				},
				["<cr>"] = "open",
				["R"] = "refresh",
				["a"] = {
					"add",
					-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
					-- some commands may take optional config options, see `:h neo-tree-mappings` for details
					config = {
						show_path = "none", -- "none", "relative", "absolute"
					},
				},
				["r"] = "rename",
				["d"] = "delete",
			},
		},
		filesystem = {
			filtered_items = {
				visible = true,
			},
			follow_current_file = {
				enabled = true,
			},
			window = {
				mappings = {
					["/"] = "fuzzy_finder",
					["D"] = "fuzzy_finder_directory",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
				},
			},
		},
	},
	init = function()
		vim.keymap.set("n", "<C-b>", ":Neotree filesystem toggle left<CR>", {})
	end,
}
