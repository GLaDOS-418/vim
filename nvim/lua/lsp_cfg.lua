-----------------------------------------
---  LSP CONFIG
-----------------------------------------

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gr", '<cmd>Telescope lsp_references<cr>', opts)
  vim.keymap.set("n", "gs", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set({ 'n', 'x' }, '<F3>', function () vim.lsp.buf.format({async = true}) end, opts)
end)

-----------------------------------------
---  INSTALL  LSP SERVERS
-----------------------------------------

-- find names for servers at:
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',         -- cpp  lsp
    'rust_analyzer',  -- rust lsp
    'gopls',          -- go lsp
    'jdtls',          -- java lsp
    'lua_ls',         -- lua lsp
    'html',           -- html LSP
  },
  handlers = {
    lsp_zero.default_setup,
    jdtls = lsp_zero.noop,
  }
})


-----------------------------------------
---  SETUP LSP SERVERS
-----------------------------------------

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls()) -- provides vim globals in lua
require('lspconfig').clangd.setup ({
    single_file_support = true,
  })

-- default setup of servers
-- do I need this after mason-lspconfig/handlers ?
-- lsp_zero.setup_servers({'rust_analyzer', 'gopls'})

-----------------------------------------
---  FORMATTING
-----------------------------------------
-- lsp_zero.format_on_save({
--   servers = {
--     ["rustfmt"] = { "rust" },
--     ["clang-format"] = { "c", "cpp" },
--     ["stylua"] = {"lua"},
--     ["html_beautifier"] = {"html"},
--     ["goimports"] = {"go"},
--   },
-- })


-----------------------------------------
---  DIAGNOSTICS
-----------------------------------------
lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = 'H',
  info = '»'
})

-----------------------------------------
---  COMPLETION/SNNIPPETS
-----------------------------------------

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({
    fields = {'abbr', 'kind', 'menu'},
    format = require('lspkind').cmp_format({
      mode = 'symbol',       -- show only symbol annotations
      maxwidth = 50,         -- prevent the popup from showing more than provided characters
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    })
  })

require('luasnip.loaders.from_vscode').lazy_load()       -- load friendly-snippets into nvim-cmp
-- require('luasnip.loaders.from_snipmate').lazy_load()  -- load honza/vim-snippets into nvim-cmp

cmp.setup({
  mapping = {
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp_action.luasnip_supertab(),
    ['<s-tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<cr>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- scroll up and down the documentation window
    ['<c-u>'] = cmp.mapping.scroll_docs(-4),
    ['<c-d>'] = cmp.mapping.scroll_docs(4),
  },

  -- completion sources
  sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },     -- hrsh7th/cmp-nvim-lua
      { name = 'buffer'   },     -- hrsh7th/cmp-buffer
      { name = 'luasnip'  },     -- saadparwaiz1/cmp_luasnip
      -- { name = 'vsnip' },     -- For vsnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' },    -- For snippy users.
    },

   -- show source name in completion menu
   formatting = cmp_format,

   -- add borders to completion menu
   window = {
     completion = cmp.config.window.bordered(),
     documentation = cmp.config.window.bordered(),
   },

   -- Make the first item in completion menu always be selected
  preselect = 'item',
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
})



-----------------------------------------
-- https://github.com/ray-x/go.nvim
-----------------------------------------
require('go').setup()

-- Run gofmt + goimport on save
 local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
 vim.api.nvim_create_autocmd("BufWritePre", {
   pattern = "*.go",
   callback = function()
     require('go.format').goimport()
   end,
   group = format_sync_grp,
 })
