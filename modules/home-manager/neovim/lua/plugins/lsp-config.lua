return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		opts = {
			servers = {
				-- -- Example LSP settings below:
				-- lua_ls = {
				--   cmd = { ... },
				--   filetypes = { ... },
				--   capabilities = { ... },
				--   on_attach = { ... },
				--   settings = {
				--     Lua = {
				--       workspace = {
				--         checkThirdParty = false,
				--       },
				--       codeLens = {
				--         enable = true,
				--       },
				--       completion = {
				--         callSnippet = "Replace",
				--       },
				--     },
				--   },
				-- },
			},
		},
		config = function(_, opts)
			-- LSP servers and clients are able to communicate to each other what features they support.
			-- By default, Neovim doesn't support everything that is in the LSP Specification.
			-- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			-- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local client_capabilities = vim.lsp.protocol.make_client_capabilities()
			-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers..
			local completion_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local capabilities = vim.tbl_deep_extend("force", client_capabilities, completion_capabilities)

			for server, server_opts in pairs(opts.servers) do
				local defaults = {}
				defaults.capabilities = capabilities
				-- TODO: This seems to keep refreshing code lens. Need to figure out more details
				--defaults.on_attach = function(client, bufnr)
				--	if client.supports_method("textDocument/codeLens") then
				--		vim.lsp.codelens.refresh()
				--		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				--			buffer = bufnr,
				--			callback = vim.lsp.codelens.refresh,
				--		})
				--	end
				--end

				-- merge defaults with user settings for this LSP server
				-- NOTE: this could technically overwrite the defaults, like capabilities or on_attach.
				local final_server_opts = vim.tbl_deep_extend("force", defaults, server_opts or {})

				-- FIXME: workaround for https://github.com/neovim/neovim/issues/28058
				for _, v in pairs(server_opts) do
					if type(v) == "table" and v.workspace then
						v.workspace.didChangeWatchedFiles = {
							dynamicRegistration = false,
							relativePatternSupport = false,
						}
					end
				end

				require("lspconfig")[server].setup(final_server_opts)
			end

			require("lspconfig").terraformls.setup({ capabilities = capabilities })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("K", vim.lsp.buf.hover, "[K]")

					vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
						border = "single",
						close_events = { "CursorMoved", "BufHidden" },
						focusable = false,
					})
					vim.keymap.set("i", "<C-K>", vim.lsp.buf.signature_help)

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				end,
			})
		end,
	},
}
