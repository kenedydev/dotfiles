return {
	"rcarriga/nvim-notify",
	lazy = false,
	opts = {
		stages = "fade",
	},
	config = function()
		vim.notify = require("notify")
	end,
}
