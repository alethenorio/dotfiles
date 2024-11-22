vim.api.nvim_create_autocmd("FileType", {
	pattern = { "proto" },
	callback = function()
		-- set proto specific options
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.colorcolumn = "80"
	end,
})

return {

	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		ft = { "proto" },
		opts = {
			formatters_by_ft = {
				proto = { "buf" },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "proto" },
		opts = {
			servers = {
				buf_ls = {},
			},
		},
	},
}
