-- stylua: ignore start

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.opt.winborder = "rounded"

-- Key mappings

-- select all text
vim.keymap.set({"n", "v" }, "<Leader>a", "<Esc>ggVG", { noremap = true, silent = true, desc = "Select all text" })

-- clear search
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlights" })

-- toggle relative numbers
vim.keymap.set("n", "<Leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { silent = true, desc = "Toggle relative numbers" })

-- toggle line wrapping
vim.keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { silent = true, desc = "Toggle line wrap" })

-- copy to system clipboard
vim.keymap.set("n", "<Leader>y", '"+yy', { noremap = true, silent = true, desc = "Copy line to system clipboard" })
vim.keymap.set("v", "<Leader>y", '"+y', { noremap = true, silent = true, desc = "Copy selection to system clipboard" })

-- copy diagnostic under cursor to system clipboard
vim.keymap.set("n", "<leader>ly", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

  if vim.tbl_isempty(diagnostics) then return end

  local d = diagnostics[1]
  local source = d.source and ("[" .. d.source .. "] ") or ""
  local code = d.code and (" (Code: " .. d.code .. ")") or ""
  local full_message = source .. d.message .. code

  vim.fn.setreg("+", full_message)
  vim.notify("Copied detailed diagnostic")
end, { desc = "Copy diagnostic to clipboard" })

-- window management
vim.keymap.set("n", "<leader>wq", "<cmd>q<cr>", { desc = "Close Window" })
vim.keymap.set("n", "<leader>wsh", "<cmd>split<cr>", { desc = "Split Window Horizontal" })
vim.keymap.set("n", "<leader>wsv", "<cmd>vsplit<cr>", { desc = "Split Window Vertical" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- quickfix list management
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close Quickfix" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open Quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix Item" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix Item" })

-- buffer management
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Switch to Other Buffer" })

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

    -- blink
    {
      'saghen/blink.cmp',
      version = '*',
      dependencies = 'rafamadriz/friendly-snippets',
      opts = {},
    },

    -- conform
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      opts = {
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          lua = { "stylua" },
          html = { "prettier" },
          css = { "prettier" },
          javascript = { "prettier" },
          python = { "ruff_format" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      },
    },

    -- copilot
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = {
            auto_trigger = true,
            debounce = 100,
            keymap = {
              accept = "<M-;>",
              accept_word = "<M-l>",
              accept_line = "<M-j>",
              toggle_auto_trigger = "<M-a>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = true,
            help = false,
            gitcommit = false,
            gitrebase = false,
            ["."] = false,
          },
        })
      end,
    },

    {
      'AndreM222/copilot-lualine'
    },

    -- fzf
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = function()
        local fzf = require("fzf-lua")
        local config = fzf.config
        local actions = fzf.actions

        config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
        config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
        config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
        config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
        config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"

        return {
          "fzf-native",
          fzf_colors = true,
          winopts = {
            height = 0.85,
            width = 0.80,
            preview = {
              layout = "vertical",
              vertical = "down:45%",
            },
          },
          ui_select = function(fzf_opts, items)
            return vim.tbl_deep_extend("force", fzf_opts, {
              winopts = {
                title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                title_pos = "center",
                width = 0.6,
                height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
              },
            })
          end,
          files = {
            actions = {
              ["alt-c"] = { actions.toggle_ignore },
              ["alt-h"] = { actions.toggle_hidden },
            },
          },
        }
      end,
      config = function(_, opts)
        require("fzf-lua").setup(opts)
        require("fzf-lua").register_ui_select(opts.ui_select)
      end,
      keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "List Buffers" },
        { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
        { "<leader>fz", "<cmd>FzfLua zoxide<cr>", desc = "Zoxide (Recent Dirs)" },
        { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },

        { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep Project" },
        { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep Word under cursor" },
        { "<leader>sv", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Grep Selection" },
        { "<leader>sb", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Grep Current Buffer" },
        { "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },
        { "<leader>su", "<cmd>FzfLua undo<cr>", desc = "Undo History" },
        { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
        { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
        { "<leader>sh", "<cmd>FzfLua command_history<cr>", desc = "Search Command History" },

        { "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>", desc = "Go to Definition" },
        { "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
        { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
        { "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Actions" },
        { "<leader>lf", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP Finder (All-in-one)" },
        { "<leader>le", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
        { "<leader>lW", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },

        { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
        { "<leader>gc", "<cmd>FzfLua git_bcommits<cr>", desc = "Git Buffer Commits" },
        { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
        { "<leader>gx", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash List" },
        { "<leader>gB", "<cmd>FzfLua git_blame<cr>", desc = "Git Blame" },
        { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff" },

        { "<leader>db", "<cmd>FzfLua dap_breakpoints<cr>", desc = "DAP Breakpoints" },
        { "<leader>dv", "<cmd>FzfLua dap_variables<cr>", desc = "DAP Variables" },
        { "<leader>df", "<cmd>FzfLua dap_frames<cr>", desc = "DAP Frames (Stack)" },
        { "<leader>dc", "<cmd>FzfLua dap_commands<cr>", desc = "DAP Commands" },

        { "<leader>hm", "<cmd>FzfLua manpages<cr>", desc = "Man Pages (Arch/C)" },
        { "<leader>hk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
        { "<leader>ht", "<cmd>FzfLua colorschemes<cr>", desc = "Test Themes" },

        { "<C-x><C-l>", function() require("fzf-lua").complete_line() end, mode = "i", desc = "Fuzzy Complete Line" },
        { "<C-x><C-f>", function() require("fzf-lua").complete_path() end, mode = "i", desc = "Fuzzy Complete Path" },
      },
    },

    -- gitsigns
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          vim.keymap.set("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk", buffer = bufnr })
          vim.keymap.set("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk (Pop-up)", buffer = bufnr })
          vim.keymap.set("n", "<leader>ghd", gs.preview_hunk_inline, { desc = "Diff Hunk (Inline)", buffer = bufnr })
          vim.keymap.set("n", "<leader>ghs", gs.stage_hunk, { desc = "Toggle Stage Hunk", buffer = bufnr })
          vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next Change", buffer = bufnr })
          vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Prev Change", buffer = bufnr })
        end,
      },
    },

    -- lazydev
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      },
    },

-- lsp
    {
      "neovim/nvim-lspconfig",
      dependencies = { "saghen/blink.cmp" },
      config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        vim.diagnostic.config({ update_in_insert = false })
        local servers = {
          clangd = {
            cmd = { "clangd", "--background-index", "--clang-tidy" },
          },
          lua_ls = {},
          pyright = {},
          ruff = {},
        }

        for server, config in pairs(servers) do
          config.capabilities = capabilities
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("LspKeybindsAndFeatures", { clear = true }),
          callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local opts = { buffer = ev.buf, silent = true }

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
            vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))

            if client and client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            end
          end,
        })
      end,
    },

    -- lualine
    {
      "nvim-lualine/lualine.nvim",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        sections = {
          lualine_c = { { "filename", path = 1 }, },
          lualine_x = { 'copilot' ,'encoding', 'fileformat', 'filetype' },
        },
      },
    },

    --snacks
    {
      "folke/snacks.nvim",
      priority = 999,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        bufdelete = { enabled = true },
        quickfile = { enabled = true },
        indent = { enabled = true },
        words = { enabled = true },
        notifier = { enabled = true },
        input = { enabled = true },
        dashboard = { enabled = true },
        terminal = { enabled = true },
        picker = { enabled = false },
        explorer = { enabled = false },
        scroll = { enabled = false },
      },
      keys = {
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
        { "<leader>t", function() Snacks.terminal() end, desc = "Toggle Terminal" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<leader>uh", function() Snacks.toggle.inlay_hints() end, desc = "Toggle Inlay Hints (LSP)" },
        { "<leader>ug", function() Snacks.toggle.indent() end, desc = "Toggle Indent Guides" },
      },
    },

    -- which-key
    {
      "folke/which-key.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "echasnovski/mini.icons",
      },
      opts = {
        preset = "helix",
        spec = {
          { "<leader>b", group = "Buffer" },
          { "<leader>d", group = "Debug/DAP" },
          { "<leader>f", group = "Find/Files" },
          { "<leader>g", group = "Git" },
          { "<leader>gh", group = "Hunks" },
          { "<leader>h", group = "Help/Misc" },
          { "<leader>l", group = "LSP/Diagnostics" },
          { "<leader>q", group = "Quickfix" },
          { "<leader>s", group = "Search/Grep" },
          { "<leader>u", group = "UI/Toggles" },
          { "<leader>w", group = "Window" },
          { "<leader>ws", group = "Split" },
        },
      },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyodark" } },
  -- automatically check for plugin updates
  -- checker = { enabled = true },
})

-- stylua: ignore end
