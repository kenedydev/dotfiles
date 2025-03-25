return {
	"kylechui/nvim-surround",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = "VeryLazy",
	opts = {
		keymaps = {
			insert = "<C-g>s",
			insert_line = "<C-g>S",
			normal = "<leader>s",
			normal_cur = "<leader>sl",
			normal_line = "<leader>slv",
			normal_cur_line = "<leader>sL",
			visual = "<leader>s",
			visual_line = "<leader>sl",
			delete = "<leader>sd",
			change = "<leader>sc",
			change_line = "<leader>scl",
		},
	},
}
