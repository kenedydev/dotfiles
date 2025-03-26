return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			sh = { "shfmt" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			json = { "prettierd" },
			markdown = { "prettierd" },
			yaml = { "prettierd" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	},
}
