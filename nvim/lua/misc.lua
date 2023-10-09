-- devdocs

require('nvim-devdocs').setup({
  after_open = function(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {})
  end
})

-- Bekaboo/dropbar.nvim
require('dropbar').setup()

-- norcalli/nvim-colorizer.lua
require('colorizer').setup()

-- -folke/todo-comments.nvim
require('todo-comments').setup()

-- folke/noice.nvim
-- require('noice').setup()

-- https://github.com/stevearc/dressing.nvim
require('dressing').setup()

-- sourcegraph/sg.nvim
-- require("sg").setup ()

