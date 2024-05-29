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
require("neogen").setup()

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup()

-- HampusHauffman/block.nvim
require("block").setup()

--epwalsh/obsidian.nvim
require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/vaults/notes/Stage I",
		},
		{
			name = "personal",
			path = "~/vaults/blog",
		},
	},
	daily_notes = {
		folder = "notes/_monthly",
		date_format = "%Y-%m",
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	new_notes_location = { "notes_subdir" },
	templates = {
		folder = "Templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		-- A map for custom variables, the key should be the variable and the value a function
		substitutions = {},
	},
	attachments = {
		img_folder = "_embeddings", -- This is the default
		img_text_func = function(client, path)
			path = client:vault_relative_path(path) or path
			return string.format("![%s](%s)", path.name, path)
		end,
	},
})
