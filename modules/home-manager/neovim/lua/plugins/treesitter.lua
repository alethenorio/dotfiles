return {
	{
		"nvim-treesitter/nvim-treesitter",
		--build = ":TSUpdate",
		opts = {
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "topline",
		},
	},
}
