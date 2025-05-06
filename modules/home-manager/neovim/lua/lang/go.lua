vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork", "gotmpl" },
	callback = function()
		-- set go specific options
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.colorcolumn = "120"
	end,
})

return {

	{
		"stevearc/conform.nvim",
		ft = { "go", "gomod", "gowork", "gotmpl" },
		opts = {
			formatters_by_ft = {
				go = {
					"gofumpt",
					-- "goimports",
					"gci",
					"golines",
				},
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
				-- goimports = {
				-- 	args = { "-srcdir", "$FILENAME" },
				-- },
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
							env = {
								-- Enable IntelliSense for Google Wire files
								GOFLAGS = "-tags=wireinject",
							},
							codelenses = {
								test = false,
							},
							staticcheck = true,
						},
					},
				},
			},
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "go" },
		dependencies = {
			{
				"fredrikaverpil/neotest-golang",
			},
		},

		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			opts.adapters["neotest-golang"] = {
				go_test_args = {
					"-v",
					"-count=1",
					"-race",
					"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
					-- "-p=1",
					"-parallel=1",
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-dap",
		ft = { "go" },
		opts = {
			adapters = {
				delve = function(callback, config)
					if config.mode == "remote" and config.request == "attach" then
						callback({
							type = "server",
							host = config.host or "127.0.0.1",
							port = config.port or "38697",
						})
					else
						local goModDir = vim.fs.root(0, "go.mod")
						if goModDir == "" or goModDir == nil then
							goModDir = vim.fn.getcwd()
						end
						print(goModDir)
						callback({
							type = "server",
							port = "${port}",
							executable = {
								command = "dlv",
								args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
								options = {
									cwd = goModDir,
									detached = vim.fn.has("win32") == 0,
								},
							},
						})
					end
				end,
			},
			configurations = {
				go = {
					{
						type = "delve",
						name = "Debug",
						request = "launch",
						program = "${file}",
					},
					{
						type = "delve",
						name = "Debug test", -- configuration for debugging test files
						request = "launch",
						mode = "test",
						program = "${file}",
					},
					-- works with go.mod packages and sub packages
					{
						type = "delve",
						name = "Debug test (go.mod)",
						request = "launch",
						mode = "test",
						program = "./${relativeFileDirname}",
					},
				},
			},
		},
	},
}
