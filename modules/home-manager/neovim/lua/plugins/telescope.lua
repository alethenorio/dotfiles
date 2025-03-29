return {
	{ "nvim-telescope/telescope-ui-select.nvim", enabled = false },
	{ "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
	{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-project.nvim" },
			{ "folke/persistence.nvim" },
		},
		opts = {
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--hidden",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim",
					"--glob",
					"!**/.git/*",
					"--glob",
					"!**/node_modules/*",
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				project = {
					base_dirs = {
						{ path = "/home/alethenorio/code", max_depth = 3 },
					},
					on_project_selected = function(prompt_bufnr)
						if vim.g.projectcwd then
							require("persistence").save()
							require("telescope._extensions.project.actions").change_working_directory(
								prompt_bufnr,
								false
							)
							require("persistence").load()
						else
							local builtin = require("telescope.builtin")
							local path =
								require("telescope._extensions.project.actions").get_selected_path(prompt_bufnr)
							builtin.find_files({ cwd = path })
						end
					end,
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("project")
			local builtin = require("telescope.builtin")
			local extensions = require("telescope").extensions
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>P", function()
				extensions.project.project({ display_type = "full", hide_workspace = true })
				vim.g.projectcwd = true
			end, { desc = "[P]rojects" })
			vim.keymap.set("n", "<leader>fp", function()
				vim.g.projectcwd = false
				extensions.project.project({ display_type = "full", hide_workspace = true })
			end, { desc = "[P]rojects" })
		end,
	},
}
