return {
	"nvim-neo-tree/neo-tree.nvim",
	enabled = false,
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
		window = {
			mappings = {
				["<C-b>"] = "none",
			},
		},
		filesystem = {
			filtered_items = {
				visible = true,
			},
			follow_current_file = {
				enabled = true,
			},
		},
	},
	init = function()
		vim.keymap.set("n", "<C-b>", ":Neotree filesystem toggle left<CR>", { silent = true })
	end,
}
