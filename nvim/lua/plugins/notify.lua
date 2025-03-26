return {
	"rcarriga/nvim-notify",
	lazy = false,
	config = function()
		local notify = require("notify")
		notify.setup({
			stages = "static",
		})
		vim.notify = notify
	end,
}
