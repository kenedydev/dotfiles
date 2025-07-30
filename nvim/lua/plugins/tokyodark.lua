return {
	"tiagovla/tokyodark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyodark").setup({
			custom_palette = {
				bg0 = "#000000",
				bg1 = "#1A1A1A",
				bg2 = "#2A2A2A",
				bg3 = "#3A3A3A",
				bg4 = "#4A4A4A",
				bg5 = "#5A5A5A",
			},
		})
		vim.cmd([[colorscheme tokyodark]])
	end,
}
