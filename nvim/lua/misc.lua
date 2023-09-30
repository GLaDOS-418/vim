-- devdocs

require('nvim-devdocs').setup({
  -- ...
  after_open = function(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {})
  end
})



-- nvimdev/lspsaga
-- require('lspsaga').setup({})


-- Bekaboo/dropbar.nvim
require('dropbar').setup()

-- norcalli/nvim-colorizer.lua
require('colorizer').setup()
