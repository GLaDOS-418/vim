-- devdocs

-- require("nvim-devdocs").setup({
-- 	after_open = function(bufnr)
-- 		vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", {})
-- 	end,
-- })

-- Bekaboo/dropbar.nvim
require("dropbar").setup()

-- NvChad/nvim-colorizer.lua
require("colorizer").setup({
	user_default_options = {
		css = true,
		tailwind = "both", -- Enable tailwind colors (true/normal/lsp/both)
		sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
	},
})

-- -folke/todo-comments.nvim
require("todo-comments").setup()

-- folke/noice.nvim
-- require('noice').setup()

-- https://github.com/stevearc/dressing.nvim
require("dressing").setup()

-- sourcegraph/sg.nvim
-- require("sg").setup ()

-- richardbizik/nvim-toc
require("nvim-toc").setup({
	toc_header = "Outline",
})

-- numToStr/Comment.nvim
require("Comment").setup()

-- stevearc/aerial.nvim
require("aerial").setup()

-- danymat/neogen
require("neogen").setup({ snippet_engine = "luasnip" })

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup()

-- kevinhwang91/nvim-ufo
-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
require("ufo").setup({
	provider_selector = function(_, _, _)
		return { "treesitter", "indent" }
	end,
})

-- HampusHauffman/block.nvim
require("block").setup()

-- akinsho/toggleterm.nvim
require("toggleterm").setup({
	direction = "float",
})

-- stevearc/oil.nvim
require("oil").setup({
	columns = {
		"icon",
		"user",
		"group",
		"permissions",
		"size",
		"mtime",
	},
	float = {
		-- Padding around the floating window
		padding = 2,
		max_width = 120,
		max_height = 0,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
	},
	preview_split = "auto",
})
vim.keymap.set("n", "=", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
