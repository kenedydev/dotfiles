return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		options = {
			separator_style = "slant",
			always_show_bufferline = false,
		},
	},
	keys = {
		{ "H", "<cmd>BufferLineCyclePrev<CR>", desc = "Go to previous buffer" },
		{ "L", "<cmd>BufferLineCycleNext<CR>", desc = "Go to next buffer" },
		{ "<Leader>boc", "<cmd>BufferLineCloseOthers<CR>", desc = "Close all other buffers" },
		{ "<Leader>brc", "<cmd>BufferLineCloseRight<CR>", desc = "Close buffers to the right" },
		{ "<Leader>blc", "<cmd>BufferLineCloseLeft<CR>", desc = "Close buffers to the left" },
		{ "<Leader>b]", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer to the right" },
		{ "<Leader>b[", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer to the left" },
		{ "<Leader>bc", "<cmd>bd<CR>", desc = "Close current buffer" },
		{ "<Leader>bd", "<cmd>bd!<CR>", desc = "Force close current buffer" },
	},
}
