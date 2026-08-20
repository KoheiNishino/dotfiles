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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.helplang = { "ja", "en" }

local function get_js_formatter(bufnr)
	if vim.fs.find({ "biome.json", "biome.jsonc" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
		return { "biome" }
	end
end

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "vim-jp/vimdoc-ja" },
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			lazy = false,
		},
		{
			"scottmckendry/cyberdream.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("cyberdream").setup({
					transparent = true,
				})
				vim.cmd("colorscheme cyberdream")
			end,
		},
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = get_js_formatter,
					javascriptreact = get_js_formatter,
					typescript = get_js_formatter,
					typescriptreact = get_js_formatter,
				},
				format_on_save = {
					timeout_ms = 500,
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})

				local base_on_attach = vim.lsp.config.eslint.on_attach

				vim.lsp.config("eslint", {
					on_attach = function(client, bufnr)
						base_on_attach(client, bufnr)

						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "LspEslintFixAll",
						})
					end,
				})

				vim.lsp.enable({ "lua_ls", "vtsls", "eslint", "biome" })
			end,
		},
		{
			"saghen/blink.cmp",
			version = "1.*",
			opts = {
				keymap = {
					preset = "super-tab",
				},
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			version = "*",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			opts = {},
		},
		{
			"stevearc/oil.nvim",
			dependencies = {
				{
					"nvim-mini/mini.icons",
					opts = {},
				},
			},
			lazy = false,
			opts = {},
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})
