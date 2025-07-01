-- # bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 1 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(2)
	end
end
vim.opt.rtp:prepend(lazypath)

-- # leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- # general settings
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
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.fixendofline = true

-- # key mappings
-- select all text with ctrl-a
vim.keymap.set({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })

-- save file with ctrl-s
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })

-- toggle relative numbers
vim.keymap.set("n", "<Leader>Tr", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { noremap = true, silent = true, desc = "Toggle relative numbers" })

-- window navigation shortcuts
vim.keymap.set("n", "<Leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "Move to lower window" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "Move to upper window" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "Move to right window" })

-- clear search
vim.keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- toggle line wrapping
vim.keymap.set("n", "<Leader>Tw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { noremap = true, silent = true, desc = "Toggle line wrap" })

-- diagnostic key mappings
-- stylua: ignore start
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Go to next diagnostic" })
vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic float" })
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Set location list with diagnostics" })
vim.keymap.set("n", "<Leader>Td", function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable(0)
  else
    vim.diagnostic.disable(0)
  end
end, { noremap = true, silent = true, desc = "Toggle diagnostics for current buffer" })
-- stylua: ignore end

-- # setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	rocks = {
		hererocks = false,
	},
	-- colorscheme that will be used when installing plugins
	install = { colorscheme = { "tokyodark" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})

-- # diagnostic signs & configuration

-- define diagnostic signs
local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = "",
}

for type, icon in pairs(diagnostic_signs) do
	vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
end

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
