-- restore only some things from the last session, to avoid restoring e.g. blank buffers
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal"

return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
		-- minimum number of file buffers that need to be open to save
		-- Set to 0 to always save
		need = 1,
		-- Save sessions based on the current working directory rather than git branch
		branch = false,
	},
}
