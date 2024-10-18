return {
	{
		"numToStr/FTerm.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("FTerm").setup(opts)
			vim.keymap.set({ "n" }, "<leader>tt", function()
				require("FTerm").toggle()
			end, { desc = "[T]oggle [T]erminal" })
		end,
	},
}
