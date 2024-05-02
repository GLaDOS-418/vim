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
