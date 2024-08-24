return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.buttons.val = {
			dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
			dashboard.button("q", " " .. " Quit", ":qa<CR>"),
		}
		return dashboard
	end,
	config = function(_, opts)
		require("alpha").setup(opts.config)
	end,
}
