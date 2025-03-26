local mason_tools = {
	"bash-language-server",
	"pyright",
	"shellcheck",
	"black",
	"isort",
	"prettierd",
	"shfmt",
	"stylua",
}

return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	config = function()
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local registry = require("mason-registry")
		registry.refresh()

		for _, tool in ipairs(mason_tools) do
			if registry.has_package(tool) then
				local pkg = registry.get_package(tool)
				if not pkg:is_installed() then
					local handle = pkg:install()
					handle:once("closed", function()
						if pkg:is_installed() then
							vim.notify(
								string.format('"%s" was successfully installed', tool),
								vim.log.levels.INFO,
								{ title = "mason.nvim" }
							)
						else
							vim.notify(
								string.format('"%s" failed to install', tool),
								vim.log.levels.ERROR,
								{ title = "mason.nvim" }
							)
						end
					end)
				end
			else
				vim.notify(string.format('"%s" not found', tool), vim.log.levels.ERROR, { title = "mason.nvim" })
			end
		end
	end,
}
