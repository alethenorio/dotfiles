vim.api.nvim_create_autocmd("FileType", {
	pattern = { "nix" },
	callback = function()
		-- set nix specific options
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})
return {

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				nix = { "nixfmt" },
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				nix = { "nix" },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				nil_ls = {},
			},
		},
	},
}
