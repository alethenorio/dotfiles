vim.filetype.add({
	-- extension = {},
	-- filename = {},
	pattern = {
		-- can be comma-separated for a list of paths
		[".*/%.github/dependabot.yml"] = "dependabot",
		[".*/%.github/dependabot.yaml"] = "dependabot",
		[".*/%.github/workflows[%w/]+.*%.yml"] = "gha",
		[".*/%.github/workflows/[%w/]+.*%.yaml"] = "gha",
		[".*/%.backstage/[^/]+%.ya?ml"] = "backstage",
	},
})

-- use the yaml parser for the custom filetypes
vim.treesitter.language.register("yaml", "gha")
vim.treesitter.language.register("yaml", "dependabot")
vim.treesitter.language.register("yaml", "backstage")

return {

	{
		"stevearc/conform.nvim",
		ft = { "yaml", "gha", "dependabot", "backstage" },
		opts = {
			formatters_by_ft = {
				-- TODO: the default is very strict, might be good to add a config
				-- file: https://github.com/google/yamlfmt/blob/main/docs/config-file.md#basic-formatter
				yaml = { "yamlfmt" },
				gha = { "yamlfmt" },
				dependabot = { "yamlfmt" },
				backstage = { "yamlfmt" },
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
		ft = { "gha", "yaml", "backstage" },
		opts = {
			linters_by_ft = {
				gha = { "actionlint" },
				yaml = { "yamllint" },
				backstage = { "yamllint" },
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
		dependencies = {
			{
				"b0o/SchemaStore.nvim",
			},
		},
		ft = { "yaml", "gha", "dependabot", "backstage" },
		opts = {
			servers = {
				yamlls = {
					-- https://github.com/redhat-developer/yaml-language-server
					filetypes = { "yaml", "gha", "dependabot", "backstage" },

					-- Have to add this for yamlls to understand that we support line folding
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},

					settings = {
						yaml = {
							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas({
								select = {
									"Catalog Info Backstage",
									"dependabot-v2.json",
									"GitHub Workflow",
								},
								extra = {
									{
										description = "Backstage Catalog Info",
										fileMatch = { "**/.backstage/*.{yaml,yml}" },
										name = "Catalog Info Backstage",
										url = "https://json.schemastore.org/catalog-info.json",
									},
								},
							}),
						},
					},
				},
			},
		},
	},
}
