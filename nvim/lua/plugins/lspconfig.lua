return {
	"neovim/nvim-lspconfig",
	dependencies = { "williamboman/mason.nvim" },
	event = "FileType",
	keys = {
    -- stylua: ignore start
    { "gd", function() vim.lsp.buf.definition() end, desc = "Go to definition" },
    { "gD", function() vim.lsp.buf.declaration() end, desc = "Go to declaration" },
    { "gi", function() vim.lsp.buf.implementation() end, desc = "Go to implementation" },
    { "gr", function() vim.lsp.buf.references() end, desc = "Find references" },
    { "gt", function() vim.lsp.buf.type_definition() end, desc = "Go to type definition" },
    { "K", function() vim.lsp.buf.hover() end, desc = "Show hover info" },
    { "<Leader>ls", function() vim.lsp.buf.signature_help() end, desc = "Show signature help" },
    { "<Leader>lr", function() vim.lsp.buf.rename() end, desc = "Rename symbol" },
    { "<Leader>lc", function() vim.lsp.buf.code_action() end, desc = "Open code actions" },
    { "<Leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format document" },
    { "<Leader>lw", function() vim.lsp.buf.workspace_symbol() end, desc = "Search workspace symbols" },
		-- stylua: ignore end
	},
	config = function()
		local lspconfig = require("lspconfig")
		lspconfig.pyright.setup({})
		lspconfig.bashls.setup({})
		lspconfig.ruby_lsp.setup({})
		lspconfig.clangd.setup({})
	end,
}
