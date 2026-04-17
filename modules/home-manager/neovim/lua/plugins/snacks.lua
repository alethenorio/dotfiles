return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		styles = {
			terminal = {
				keys = {
					term_normal = false,
				},
			},
		},
		dashboard = { enabled = true },
		explorer = { enabled = true },
		git = { enabled = true },
		gitbrowse = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				gh_issue = {},
				explorer = {
					win = {
						list = {
							keys = {
								["<PageDown>"] = "list_scroll_down",
								["<PageUp>"] = "list_scroll_up",
							},
						},
						input = {
							keys = {
								["<PageDown>"] = { "list_scroll_down", mode = { "i", "n" } },
								["<PageUp>"] = { "list_scroll_up", mode = { "i", "n" } },
							},
						},
					},
				},
				-- <A-d> in the PR picker toggles hiding/showing draft PRs
				gh_pr = {
					toggles = {
						hide_drafts = "d",
					},
					transform = function(item, ctx)
						if ctx.picker.opts.hide_drafts and item.draft then
							return false
						end
					end,
					win = {
						input = {
							keys = {
								["<a-d>"] = { "toggle_hide_drafts", mode = { "n", "i" }, desc = "Toggle Draft PRs" },
							},
						},
					},
				},
			},
		},
		-- quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		terminal = { enabled = true },
		toggle = { enabled = true },
		words = { enabled = true },
		gh = { enabled = true },
	},
	keys = {
		{
			"<leader>n",
			function()
				require("snacks").picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>e",
			function()
				require("snacks").explorer({
					watch = true,
					hidden = true,
					auto_close = false,
				})
			end,
			desc = "File Explorer",
		},
		{
			"<leader>gB",
			function()
				require("snacks").gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>sg",
			function()
				require("snacks").picker.grep()
			end,
			desc = "[S]earch [G]rep",
		},
		{
			"<leader>sh",
			function()
				require("snacks").picker.help()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sk",
			function()
				require("snacks").picker.keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>sf",
			function()
				require("snacks").picker.files()
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sp",
			function()
				require("snacks").picker.projects({
					dev = {
						"~/code",
						"~/code/einride",
						"~/code/einride-labs",
					},
				})
			end,
			desc = "[S]earch [P]rojects",
		},
		{

			"<leader>sw",
			function()
				require("snacks").picker.projects({
					dev = {
						"~/code/einride/.workspaces",
					},
				})
			end,
			desc = "[S]earch [W]orkspaces",
		},
		{
			"<leader>sd",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>tt",
			function()
				require("snacks").terminal()
			end,
			-- mode = { "n", "v" },
			desc = "Toggle Terminal",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				require("snacks").toggle.diagnostics():map("<leader>ud")
			end,
		})
	end,
}
