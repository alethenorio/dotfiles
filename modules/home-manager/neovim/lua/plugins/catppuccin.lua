return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin-nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
