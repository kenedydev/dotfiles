return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		trouble = true,
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, { desc = "Navigate to next hunk" })

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, { desc = "Navigate to previous hunk" })

			map("n", "]H", function()
				gs.nav_hunk("last")
			end, { desc = "Last Hunk" })

			map("n", "[H", function()
				gs.nav_hunk("first")
			end, { desc = "First Hunk" })

			-- Actions
			map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
			map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })

			map("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage selected hunk" })

			map("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Reset selected hunk" })

			map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage entire buffer" })
			map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset entire buffer" })
			map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
			map("n", "<leader>gi", gs.preview_hunk_inline, { desc = "Preview inline hunk" })

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, { desc = "Show blame for line" })

			map("n", "<leader>gd", gs.diffthis, { desc = "Diff this hunk" })

			map("n", "<leader>gD", function()
				gs.diffthis("~")
			end, { desc = "Diff against previous commit" })

			map("n", "<leader>gQ", function()
				gs.setqflist("all")
			end, { desc = "Set quickfix list with all hunks" })
			map("n", "<leader>gq", gs.setqflist, { desc = "Set quickfix list with hunks" })

			-- Toggles
			map("n", "<leader>Tb", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
			map("n", "<leader>Td", gs.toggle_deleted, { desc = "Toggle deleted lines" })
			map("n", "<leader>Tw", gs.toggle_word_diff, { desc = "Toggle word diff" })

			-- Text object
			map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Select hunk" })
		end,
	},
}
