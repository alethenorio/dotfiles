return {
	{
		"nvim-treesitter/nvim-treesitter",
		--build = ":TSUpdate",
		opts = {
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			local config = require("nvim-treesitter.configs")
			config.setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 1,
			mode = "topline",
		},
	},
}
