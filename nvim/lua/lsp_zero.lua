local lsp = require('lsp-zero').preset({})

lsp.default_keymaps({
  buffer = bufnr,
  preserve_mappings = false
})

-- find names for servers
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servershttps://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
lsp.ensure_installed({
  -- Replace these with whatever servers you want to install
  'clangd',
  'cmake',
  'rust_analyzer',
  'gopls',
  'java_language_server',
  'lua_ls'
})

-- lsp.format_on_save({
--   servers = {
--     ["rust_analyzer"] = { "rust" },
--     ["clangd"] = { "c", "cpp", "h" },
--   },
-- })

-- " (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
-- require("luasnip.loaders.from_snipmate").load({paths = "~/snippets"})
-- require("luasnip.loaders.from_snipmate").load({ include = { "c" } }) -- Load only python snippets

require('lspconfig').clangd.setup {}
require('lspconfig').rust_analyzer.setup {}
require('lspconfig').gopls.setup {}
require('lspconfig').java_language_server.setup {}

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

-- add borders to completion menu
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

cmp.setup({
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<Tab>'] = cmp.mapping.select_next_item(select_opts),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<Enter>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts) 
  end
})

lsp.setup()
