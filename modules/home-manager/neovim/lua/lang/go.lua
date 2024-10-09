vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork", "gotmpl" },
	callback = function()
		-- set go specific options
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

return {

	{
		"stevearc/conform.nvim",
		ft = { "go", "gomod", "gowork", "gotmpl" },
		opts = {
			formatters_by_ft = {
				go = { "gofumpt", "goimports", "gci", "golines" },
			},
			formatters = {
				gofumpt = {
					prepend_args = { "-extra" },
				},
				gci = {
					args = {
						"write",
						"--skip-generated",
						"-s",
						"standard",
						"-s",
						"default",
						"--skip-vendor",
						"$FILENAME",
					},
				},
				goimports = {
					args = { "-srcdir", "$FILENAME" },
				},
				golines = {
					-- golines will use goimports as base formatter by default which is slow.
					-- see https://github.com/segmentio/golines/issues/33
					prepend_args = { "--base-formatter=gofumpt", "--ignore-generated", "--tab-len=1", "--max-len=120" },
				},
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "go", "gomod", "gowork", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
		opts = {
			servers = {
				gopls = {
					-- main readme: https://github.com/golang/tools/blob/master/gopls/doc/features/README.md
					--
					-- for all options, see:
					-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
					-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
					-- for more details, also see:
					-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
					-- https://github.com/golang/tools/blob/master/gopls/README.md

					settings = {

						-- NOTE: this is not an explicit list. The gopls defaults will apply if not overridden here.
						gopls = {
							analyses = {
								-- https://github.com/golang/tools/blob/master/gopls/internal/settings/analysis.go
								-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md

								-- the traditional vet suite
								appends = true,
								asmdecl = true,
								assign = true,
								atomic = true,
								bools = true,
								buildtag = true,
								cgocall = true,
								composite = true,
								copylock = true,
								defers = true,
								deprecated = true,
								directive = true,
								errorsas = true,
								framepointer = true,
								httpresponse = true,
								ifaceassert = true,
								loopclosure = true,
								lostcancel = true,
								nilfunc = true,
								printf = true,
								shift = true,
								sigchanyzer = true,
								slog = true,
								stdmethods = true,
								stdversion = true,
								stringintconv = true,
								structtag = true,
								testinggoroutine = true,
								tests = true,
								timeformat = true,
								unmarshal = true,
								unreachable = true,
								unsafeptr = true,
								unusedresult = true,

								-- not suitable for vet:
								-- - some (nilness) use go/ssa; see #59714.
								-- - others don't meet the "frequency" criterion;
								--   see GOROOT/src/cmd/vet/README.
								atomicalign = true,
								deepequalerrors = true,
								nilness = true,
								sortslice = true,
								embeddirective = true,

								-- disabled due to high false positives
								shadow = false,
								useany = false,
								-- fieldalignment = false, -- annoying and also  NOTE: deprecated in gopls v0.17.0

								-- "simplifiers": analyzers that offer mere style fixes
								-- gofmt -s suite:
								simplifycompositelit = true,
								simplifyrange = true,
								simplifyslice = true,
								-- other simplifiers:
								infertypeargs = true,
								unusedparams = true,
								unusedwrite = true,

								-- type-error analyzers
								-- These analyzers enrich go/types errors with suggested fixes.
								fillreturns = true,
								nonewvars = true,
								noresultvalues = true,
								stubmethods = true,
								undeclaredname = true,
								unusedvariable = true,
							},
							codelenses = {
								-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							-- completion options
							-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
							usePlaceholders = true,
							completeUnimported = true,
							experimentalPostfixCompletions = true,
							completeFunctionCalls = true,
							-- build options
							-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
							directoryFilters = { "-**/node_modules", "-**/.git", "-.vscode", "-.idea", "-.vscode-test" },
							-- formatting options
							-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
							gofumpt = false, -- handled by conform instead.
							-- ui options
							-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
							semanticTokens = false, -- disabling this enables treesitter injections (for sql, json etc)
							-- diagnostic options
							-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
							staticcheck = true,
							vulncheck = "imports",
							analysisProgressReporting = true,
						},
					},
				},
			},
		},
	},
}
