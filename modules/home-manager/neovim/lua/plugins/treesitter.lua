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
			mode = "topline",
		},
	},
}
