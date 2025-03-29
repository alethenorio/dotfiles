return {
	"nvim-telescope/telescope-file-browser.nvim",
	enabled = false,
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		extensions = {
			file_browser = {
				depth = false,
				auto_depth = true,
			},
		},
	},
	config = function(_, opts)
		-- opts.extensions.file_browser.auto_depth = true
		-- open file_browser with the path of the current buffer
		vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
	end,
}
