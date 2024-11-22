return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		-- Save sessions based on the current working directory rather than git branch
		branch = false,
	},
}
