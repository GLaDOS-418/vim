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
-- It's common to have TODO(author) but, the plugin does not support it out of the box. Below are two workarounds:
-- https://github.com/folke/todo-comments.nvim/pull/255#issuecomment-2049839007
-- https://github.com/folke/todo-comments.nvim/issues/10#issuecomment-2446101986
require("todo-comments").setup({
	search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
	highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
})

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

--- lewis6991/gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Always show sign column
  update_debounce = 1000,  -- Equivalent to 'updatetime' for signs
  numhl = false, -- disables number highlighting
  linehl = false,
  current_line_blame = false,

  -- Mappings
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', 'gn', gs.next_hunk)
    map('n', 'gp', gs.prev_hunk)

    -- Actions
    map('n', 'ga', gs.stage_hunk)
    map('n', 'gu', gs.undo_stage_hunk)
    map('n', '<leader>hp', gs.preview_hunk)
  end
}

--- folke/trouble.nvim
require('trouble').setup({})
