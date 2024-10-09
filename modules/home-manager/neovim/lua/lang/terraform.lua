return {

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				terraformls = {},
			},
		},
	},
}
