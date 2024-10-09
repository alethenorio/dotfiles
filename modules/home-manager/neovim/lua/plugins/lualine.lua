return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "auto",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diagnostics" },
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = { "encoding", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		extensions = { "neo-tree", "lazy" },
	},
	config = function(_, opts)
		if opts.noice then
			table.insert(opts.sections.lualine_x, 3, opts.noice.lualine_component)
		end

		require("lualine").setup(opts)
	end,
}
