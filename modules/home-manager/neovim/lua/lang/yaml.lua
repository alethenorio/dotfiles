vim.filetype.add({
	-- extension = {},
	-- filename = {},
	pattern = {
		-- can be comma-separated for a list of paths
		[".*/%.github/dependabot.yml"] = "dependabot",
		[".*/%.github/dependabot.yaml"] = "dependabot",
		[".*/%.github/workflows[%w/]+.*%.yml"] = "gha",
		[".*/%.github/workflows/[%w/]+.*%.yaml"] = "gha",
	},
})

-- use the yaml parser for the custom filetypes
vim.treesitter.language.register("yaml", "gha")
vim.treesitter.language.register("yaml", "dependabot")

return {

	{
		"stevearc/conform.nvim",
		ft = { "yaml", "gha", "dependabot" },
		opts = {
			formatters_by_ft = {
				-- TODO: the default is very strict, might be good to add a config
				-- file: https://github.com/google/yamlfmt/blob/main/docs/config-file.md#basic-formatter
				-- fix:
				--   - do not remove empty lines
				yaml = { "yamlfmt" },
				gha = { "yamlfmt" },
				dependabot = { "yamlfmt" },
			},
			formatters = {
				yamlfmt = {
					prepend_args = { "-formatter", "retain_line_breaks_single=true" },
				},
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		ft = { "gha", "yaml" },
		opts = {
			linters_by_ft = {
				gha = { "actionlint" },
				yaml = { "yamlllint" },
			},
			linters = {
				yamllint = {
					append_args = { "-d", "{extends: default, rules: {line-length: disable}}" },
				},
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "yaml", "gha", "dependabot" },
		opts = {
			servers = {
				yamlls = {
					-- https://github.com/redhat-developer/yaml-language-server
					filetypes = { "yaml", "gha", "dependabot" },

					-- Have to add this for yamlls to understand that we support line folding
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},
				},
			},
		},
	},
}
