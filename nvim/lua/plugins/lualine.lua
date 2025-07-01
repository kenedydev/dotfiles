return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sections = {
			lualine_c = {
				{ "filename", path = 1 }, -- or path = 3 for absolute path
			},
		},
	},
}
