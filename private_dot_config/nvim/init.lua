require("config.lazy")

-- 言語設定
vim.cmd("language en_US")

-- カラースキーム
vim.cmd("colorscheme cyberdream")

-- コマンドの際にはzshを使う
vim.opt.shell = "/bin/zsh"

-- 行番号を表示
vim.opt.number = true

-- カーソル行をハイライト
vim.opt.cursorline = true

-- カーソル行からの相対行数を表示
vim.opt.relativenumber = true

-- sign columnを常に表示
vim.opt.signcolumn = "yes"

-- Neovimが「一定時間操作されていない」と判断するまでの時間
vim.opt.updatetime = 200

-- 検索で大文字小文字を区別しない
vim.opt.ignorecase = true

-- 検索文字列に大文字が1文字でも含まれていたら大文字小文字を区別する
vim.opt.smartcase = true

-- 画面を縦分割する際に右に開く
vim.opt.splitright = true

-- 画面を横分割する際に下に開く
vim.opt.splitbelow = true

-- Indentの幅
vim.opt.shiftwidth = 2

-- タブに変換されるサイズ
vim.opt.tabstop = 2

-- タブの入力の際にスペース
vim.opt.expandtab = true

-- ワードラッピングなし
vim.opt.textwidth = 0

-- 自動インデント
vim.opt.autoindent = true

-- Searchのハイライト
vim.opt.hlsearch = true

-- クリップボードへの登録
vim.opt.clipboard = "unnamedplus"

-- マウス操作を無効
vim.opt.mouse = ""

-- lualineを表示
vim.opt.cmdheight = 0
vim.opt.showmode = false

-- リーダーキー
vim.g.mapleader = " "

-- SyntaxをEnable
-- vim.cmd("syntax on")

-- diagnosticをインライン表示
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
})

-- ESC の代わりに jj で Insert mode -> Normal mode
vim.keymap.set("i", "jj", "<Esc>", { silent = true })

-- キーマップ
vim.keymap.set("x", "p", "P", { desc = "Paste without change register" })
vim.keymap.set("x", "P", "p", { desc = "Paste with change register" })
vim.keymap.set({ "n", "x" }, "x", '"_d', { desc = "Delete using blackhole register" })
vim.keymap.set("n", "X", '"_D', { desc = "Delete using blackhole register" })
vim.keymap.set("o", "x", "d", { desc = "Delete using x" })
vim.keymap.set("c", "<c-b>", "<left>", { desc = "Emacs like left" })
vim.keymap.set("c", "<c-f>", "<right>", { desc = "Emacs like right" })
vim.keymap.set("c", "<c-a>", "<home>", { desc = "Emacs like home" })
vim.keymap.set("c", "<c-e>", "<end>", { desc = "Emacs like end" })
vim.keymap.set("c", "<c-h>", "<bs>", { desc = "Emacs like bs" })
vim.keymap.set("c", "<c-d>", "<del>", { desc = "Emacs like del" })
vim.keymap.set("n", "<space>;", "@:", { desc = "Re-run the last command" })
vim.keymap.set("n", "<space>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set({ "n", "x" }, "so", ":source<cr>", { silent = true, desc = "Source current script" })
vim.keymap.set("c", "<c-n>", function()
	return vim.fn.wildmenumode() == 1 and "<c-n>" or "<down>"
end, { expr = true, desc = "Select next" })
vim.keymap.set("c", "<c-p>", function()
	return vim.fn.wildmenumode() == 1 and "<c-p>" or "<up>"
end, { expr = true, desc = "Select previous" })
vim.keymap.set("n", "<space>q", function()
	if not pcall(vim.cmd.tabclose) then
		vim.cmd.quit()
	end
end, { desc = "Quit current tab or window" })
vim.keymap.set("ca", "qw", function()
	return vim.fn.getcmdtype() == ":" and "wq" or "qw"
end, {
	expr = true,
	desc = "Fix typo",
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Oil
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Vim起動時にIMEを英数にする
vim.fn.system("im-select com.apple.keylayout.ABC")

-- InsertモードからNormalモードへ戻った時に日本語入力を解除
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "silent !/opt/homebrew/bin/im-select com.apple.keylayout.ABC",
})

-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(event)
		local dir = vim.fs.dirname(event.file)
		local force = vim.v.cmdbang == 1

		if
			vim.fn.isdirectory(dir) == 0
			and (force or vim.fn.confirm('"' .. dir .. '" does not exist. Create?', "&Yes\n&No") == 1)
		then
			vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), "p")
		end
	end,
	desc = "Auto mkdir to save file",
})

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/7b6cc8949f9999c5ed91436cbe24aa5f99c42025/README.md
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"lua",
	},
	callback = function()
		vim.treesitter.start()
	end,
})
