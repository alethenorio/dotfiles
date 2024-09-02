-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	dev = {
		path = vim.g.nix_packages_path,
		-- "" = wildcard
		patterns = { "" },
	},
	performance = {
		-- Do not reset the runtime and package paths so we have all nix installed
		-- plugins available to us
		reset_packpath = false,
		rtp = {
			reset = false,
		},
	},
	install = {
		missing = false,
	},
})