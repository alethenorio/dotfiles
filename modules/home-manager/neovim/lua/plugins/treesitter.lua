return {
	{
		"nvim-treesitter/nvim-treesitter",
		--build = ":TSUpdate",
		init = function()
			-- Enable treesitter highlighting for all file types
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
					-- Skip special buffers (prompts, terminals, popups, etc.)
					if buftype == "" or buftype == "acwrite" then
						vim.treesitter.start(buf)
					end
				end,
			})
		end,
		opts = {
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "topline",
		},
	},
}
