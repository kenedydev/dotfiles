-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.fixendofline = true

local plugins = {} -- Table tracking plugins to install and manage
local install_path = vim.fn.stdpath("config") .. "/pack/plugins/start/" -- Plugin installation directory

-- Function to install or update plugins
local function update_plugins()
    print("Updating Neovim plugins...")

    for repository, _ in pairs(plugins) do
        local plugin_name = repository:match(".*/(.-)%.git$")
        local plugin_path = install_path .. plugin_name

        if vim.fn.isdirectory(plugin_path) == 0 then
            print("Cloning " .. plugin_name .. "...")
            vim.fn.system("git clone --depth=1 " .. repository .. " " .. plugin_path)
        else
            print("Updating " .. plugin_name .. "...")
            vim.fn.system("git -C " .. plugin_path .. " pull --ff-only")
        end
    end

    print("Plugin update complete! Restart Neovim if necessary.")
end

-- Create the command to update plugins manually
vim.api.nvim_create_user_command("UpdatePlugins", update_plugins, {})

-- Function to safely require a plugin
local function safe_require(module_name)
    local ok, module = pcall(require, module_name)
    return ok and module or nil
end

-- Helper function to encapsulate plugin configuration
local function use(module, opts)
    opts = opts or {}

    if opts.repository then
        plugins[opts.repository] = true
    end

    if opts.dependencies then
        for _, dep in ipairs(opts.dependencies) do
            plugins[dep] = true
        end
    end

    local plugin = safe_require(module)
    if plugin and opts.config then
        opts.config(plugin)
    else
        vim.schedule(function()
            vim.notify("Could not load: " .. module, vim.log.levels.WARN)
        end)
    end
end

-- Plugin configurations
use("tokyonight", {
    repository = "https://github.com/folke/tokyonight.nvim.git",
    config = function(tokyonight)
        tokyonight.setup({ style = "night" })
        tokyonight.load()
    end
})

use("bufferline", {
    repository = "https://github.com/akinsho/bufferline.nvim.git",
    dependencies = { "https://github.com/nvim-tree/nvim-web-devicons.git" },
    config = function(bufferline)
        bufferline.setup({ options = { separator_style = "slant", always_show_bufferline = false } })
    end
})

use("lualine", {
    repository = "https://github.com/nvim-lualine/lualine.nvim.git",
    dependencies = { "https://github.com/nvim-tree/nvim-web-devicons.git" },
    config = function(lualine)
        lualine.setup({})
    end
})

use("nvim-treesitter.configs", {
    repository = "https://github.com/nvim-treesitter/nvim-treesitter.git",
    config = function(treesitter)
        treesitter.setup({
            ensure_installed = { "ruby", "python", "html", "css", "javascript", "c", "cpp", "lua", "markdown", "markdown_inline" },
            highlight = { enable = true },
            auto_install = true,
            indent = { enable = false },
        })
    end
})

use("Comment", {
    repository = "https://github.com/numToStr/Comment.nvim.git",
    config = function(comment)
        comment.setup({})
    end
})

use("mini.pairs", {
    repository = "https://github.com/echasnovski/mini.pairs.git",
    config = function(mini_pairs)
        mini_pairs.setup({})
    end
})

use("ibl", {
    repository = "https://github.com/lukas-reineke/indent-blankline.nvim.git",
    config = function(ibl)
        ibl.setup({ indent = { char = "│", tab_char = "│" }, scope = { show_start = false, show_end = false } })
    end
})

use("which-key", {
    repository = "https://github.com/folke/which-key.nvim.git",
    dependencies = {
        "https://github.com/echasnovski/mini.icons.git",
        "https://github.com/nvim-tree/nvim-web-devicons.git"
    },
    config = function(which_key)
        which_key.setup({ preset = "helix" })
    end
})

-- Key mappings
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("v", "<C-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", "\"+yy", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })

-- Toggle relative numbers
vim.keymap.set("n", "<Leader>rn", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { noremap = true, silent = true, desc = "Toggle relative numbers" })

-- BufferLine shortcuts
if safe_require("bufferline") then
  vim.keymap.set("n", "<Leader>bh", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
  vim.keymap.set("n", "<Leader>bl", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Go to next buffer" })
  vim.keymap.set("n", "<Leader>bco", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true, desc = "Close all other buffers" })
  vim.keymap.set("n", "<Leader>bcr", ":BufferLineCloseRight<CR>", { noremap = true, silent = true, desc = "Close buffers to the right" })
  vim.keymap.set("n", "<Leader>bcl", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true, desc = "Close buffers to the left" })
  vim.keymap.set("n", "<Leader>b]", ":BufferLineMoveNext<CR>", { noremap = true, silent = true, desc = "Move buffer to the right" })
  vim.keymap.set("n", "<Leader>b[", ":BufferLineMovePrev<CR>", { noremap = true, silent = true, desc = "Move buffer to the left" })
end
vim.keymap.set("n", "<Leader>bcc", ":bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })
vim.keymap.set("n", "<Leader>bd", ":bd!<CR>", { noremap = true, silent = true, desc = "Force close current buffer" })

-- Window shortcuts
vim.keymap.set("n", "<Leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "Move to the window on the left" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "Move to the window below" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "Move to the window above" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "Move to the window on the right" })

-- Toggle wrap
vim.keymap.set("n", "<leader>lw", function()
    vim.opt.wrap = not vim.opt.wrap:get()
end, { noremap = true, silent = true, desc = "Toggle wrap" })
