return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		--cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					if vim.g.auto_format then
						require("conform").format({
							bufnr = args.buf,
							timeout_ms = 5000,
							lsp_fallback = true,
						})
					else
					end
				end,
			})
			require("conform").setup(opts)
		end,
	},
}
