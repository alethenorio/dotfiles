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
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				terraform = { "terraform_validate", "tflint", "tfsec" },
				tf = { "terraform_validate", "tflint", "tfsec" },
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
