-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 99
vim.opt.wrap = false
vim.opt.fixendofline = true

-- Key mappings
-- dvorak keymaps
vim.keymap.set({ "n", "x", "o" }, "t", "j", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "n", "k", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "s", "l", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "l", "n", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "L", "N", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "T", "4j", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "N", "4k", { noremap = true, silent = true })

-- select all text with ctrl-a
vim.keymap.set({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })

-- save file with ctrl-s
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })

-- clear search
vim.keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- toggle relative numbers
vim.keymap.set("n", "<Leader>Tr", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { noremap = true, silent = true, desc = "Toggle relative numbers" })

-- toggle line wrapping
vim.keymap.set("n", "<Leader>Tw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { noremap = true, silent = true, desc = "Toggle line wrap" })

-- diagnostic key mappings
-- stylua: ignore start
vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic float" })
vim.keymap.set("n", "<Leader>Td", function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable(0)
  else
    vim.diagnostic.disable(0)
  end
end, { noremap = true, silent = true, desc = "Toggle diagnostics for current buffer" })
-- stylua: ignore end

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- tokyodark
		{
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
		},

		-- bufferline
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				options = {
					separator_style = "slant",
					always_show_bufferline = false,
				},
			},
			keys = {
				{ "H", "<cmd>BufferLineCyclePrev<CR>", desc = "Go to previous buffer" },
				{ "S", "<cmd>BufferLineCycleNext<CR>", desc = "Go to next buffer" },
				{ "<Leader>bs", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer to the right" },
				{ "<Leader>bh", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer to the left" },
				{ "<Leader>bc", "<cmd>bd<CR>", desc = "Close current buffer" },
				{ "<Leader>bd", "<cmd>bd!<CR>", desc = "Force close current buffer" },
			},
		},

		-- conform
		{
			"stevearc/conform.nvim",
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
					timeout_ms = 3000,
					lsp_format = "fallback",
				},
			},
		},

		-- gitsigns
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				on_attach = function(bufnr)
					local gs = require("gitsigns")
					vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk", buffer = bufnr })
					vim.keymap.set(
						"n",
						"<leader>gd",
						gs.preview_hunk_inline,
						{ desc = "Diff this hunk", buffer = bufnr }
					)
				end,
			},
		},

		-- lsp
		{
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason.nvim" },
			event = "FileType",
			keys = {
        -- stylua: ignore start
        { "gd", function() vim.lsp.buf.definition() end, desc = "Go to definition" },
        { "gD", function() vim.lsp.buf.declaration() end, desc = "Go to declaration" },
        { "gi", function() vim.lsp.buf.implementation() end, desc = "Go to implementation" },
        { "gr", function() vim.lsp.buf.references() end, desc = "Find references" },
        { "gy", function() vim.lsp.buf.type_definition() end, desc = "Go to type definition" },
        { "K", function() vim.lsp.buf.hover() end, desc = "Show hover info" },
        { "<Leader>ls", function() vim.lsp.buf.signature_help() end, desc = "Show signature help" },
        { "<Leader>lr", function() vim.lsp.buf.rename() end, desc = "Rename symbol" },
        { "<Leader>lc", function() vim.lsp.buf.code_action() end, desc = "Open code actions" },
        { "<Leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format document" },
        { "<Leader>lw", function() vim.lsp.buf.workspace_symbol() end, desc = "Search workspace symbols" },
				-- stylua: ignore end
			},
			config = function()
				vim.lsp.enable("pyright")
				vim.lsp.enable("bashls")
				vim.lsp.enable("ruby_lsp")
				vim.lsp.enable("clangd")
			end,
		},

		-- lualine
		{
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
		},

		-- mason
		{
			"mason-org/mason.nvim",
			opts = {},
		},

		-- mini.indentscope
		{
			"nvim-mini/mini.indentscope",
			version = false,
			opts = {
				-- symbol = "▏",
				symbol = "│",
				options = { try_as_border = true },
			},
		},

		-- notify
		{
			"rcarriga/nvim-notify",
			lazy = false,
			config = function()
				local notify = require("notify")
				notify.setup({
					stages = "static",
				})
				vim.notify = notify
			end,
		},

		-- nvim-treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					highlight = { enable = true },
					ensure_installed = {
						"bash",
						"c",
						"diff",
						"html",
						"javascript",
						"jsdoc",
						"json",
						"jsonc",
						"lua",
						"luadoc",
						"luap",
						"markdown",
						"markdown_inline",
						"printf",
						"python",
						"query",
						"regex",
						"toml",
						"tsx",
						"typescript",
						"vim",
						"vimdoc",
						"xml",
						"yaml",
						"ruby",
					},
				})
			end,
		},

		-- which-key.nvim
		{
			"folke/which-key.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
				"echasnovski/mini.icons",
			},
			opts = {
				preset = "helix",
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "tokyodark" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})

-- Diagnostic signs & configuration

-- define diagnostic signs
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })

-- configure diagnostics
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 2 },
	signs = true,
	underline = false,
	severity_sort = true,
	float = { border = "rounded", source = "always" },
})

-- custom diagnostic highlight colors
vim.cmd([[
  highlight DiagnosticError guifg=#F44747 gui=italic
  highlight DiagnosticWarn  guifg=#FF8800 gui=italic
  highlight DiagnosticInfo  guifg=#4FC1FF gui=italic
  highlight DiagnosticHint  guifg=#D7BA7D gui=italic
]])
