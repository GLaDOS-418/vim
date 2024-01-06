-----------------------------------------
---  LSP CONFIG
-----------------------------------------

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
	vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", opts)
	vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
	vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
	vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.keymap.set("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	--- vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
	vim.keymap.set({ "n", "v" }, "<F3>", function()
		require("conform").format({
			timeout_ms = 500,
			async = false,
			lsp_fallback = true,
		})
	end, opts)
end)

-- required later during formatter/linter auto setup
local lsp_augroup = vim.api.nvim_create_augroup("Lsp", { clear = true })

-----------------------------------------
---  INSTALL  LSP SERVERS
-----------------------------------------

-- find names for servers at:
-- https://mason-registry.dev/registry/list
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd", -- cpp
		"rust_analyzer", -- rust
		"gopls", -- go
		"jdtls", -- java
		"lua_ls", -- lua
		"html", -- html
		"cssls", -- css
		"biome", -- json
	},
	handlers = {
		lsp_zero.default_setup,
		jdtls = lsp_zero.noop,
	},
})

-----------------------------------------
---  SETUP LSP SERVERS
-----------------------------------------

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls()) -- provides vim globals in lua
require("lspconfig").clangd.setup({
	single_file_support = true,
})

-- default setup of servers
-- do I need this after mason-lspconfig/handlers ?
-- lsp_zero.setup_servers({'rust_analyzer', 'gopls'})

-----------------------------------------
---  INSTALL FORMATTERS & LINTERS
-----------------------------------------
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"luacheck",

		"golines",
		"goimports-reviser",
		"gofumpt",
		"gomodifytags",
		"gotests",
		"golangci-lint",

		"clang-format",
		"cpplint",

		-- "htmlbeautifier",
		"prettierd",
		"jq",

		-- "codespell",
	},
})

-----------------------------------------
---  FORMATTING
-----------------------------------------
require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		cmake = { "cmake_format" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		html = { "htmlbeautifier" },
		json = { "clang_format" }, -- jq can be used alternatively

		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },

		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
		go = { "golines", "goimports-reviser", "gofumpt" },

		-- "*" filetype to run formatters on all filetypes.
		-- ["*"] = { "codespell" },

		-- "_" filetype to run formatters on filetypes that don't have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
	-- format_on_save = {
	-- 	-- These options will be passed to conform.format()
	-- 	timeout_ms = 500,
	-- 	async = false,
	-- 	lsp_fallback = true,
	-- },
})

-- automatically format buffer on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_augroup,
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-----------------------------------------
---  LINTING
-----------------------------------------

-- mfussenegger/nvim-lint
local lint = require("lint")

lint.linters_by_ft = {
	c = { "cpplint" },
	cpp = { "cpplint" },
	-- go = { "golangci-lint" },
	lua = { "luacheck" },
}

-- luacheck ignore "vim" global variable error diagnostics
table.insert(lint.linters.luacheck.args, "--globals")
table.insert(lint.linters.luacheck.args, "vim")

-- automatically lint buffer after save
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lsp_augroup,
	callback = function()
		lint.try_lint()
	end,
})

-----------------------------------------
---  DIAGNOSTICS
-----------------------------------------
lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "H",
	info = "»",
})

-----------------------------------------
---  COMPLETION/SNNIPPETS
-----------------------------------------

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = require("lsp-zero").cmp_format({
	fields = { "abbr", "kind", "menu" },
	format = require("lspkind").cmp_format({
		mode = "symbol", -- show only symbol annotations
		maxwidth = 50, -- prevent the popup from showing more than provided characters
		ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		menu = {
			nvim_lsp = "[LSP]",
			nvim_lua = "[LUA]",
			buffer = "[BUF]",
			emoji = "[EMOJI]",
			path = "[PATH]",
			luasnip = "[SNIP]",
		},
		-- before = function(entry, vim_item)
		-- 	if entry.source.name == "html-css" then
		-- 		vim_item.menu = entry.completion_item.menu
		-- 	end
		-- 	return vim_item
		-- end,
	}),
})

require("luasnip.loaders.from_vscode").lazy_load() -- load friendly-snippets into nvim-cmp
-- require("luasnip.loaders.from_snipmate").lazy_load() -- load honza/vim-snippets into nvim-cmp

cmp.setup({
	mapping = {
		["<c-space>"] = cmp.mapping.complete(),
		["<tab>"] = cmp_action.luasnip_supertab(),
		["<s-tab>"] = cmp_action.luasnip_shift_supertab(),
		["<cr>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- scroll up and down the documentation window
		["<c-u>"] = cmp.mapping.scroll_docs(-4),
		["<c-d>"] = cmp.mapping.scroll_docs(4),
	},

	-- completion sources
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" }, -- hrsh7th/cmp-nvim-lua
		{ name = "buffer" }, -- hrsh7th/cmp-buffer
		{ name = "emoji" }, -- hrsh7th/cmp-emoji
		{ name = "path" }, -- hrsh7th/cmp-path
		{ name = "luasnip" }, -- saadparwaiz1/cmp_luasnip
		-- { name = 'vsnip'     } , -- For vsnip users.
		-- { name = 'ultisnips' } , -- For ultisnips users.
		-- { name = 'snippy'    } , -- For snippy users.
		-- {
		-- 	name = "html-css", -- Jezda1337/nvim-html-css
		-- 	option = {
		-- 		max_count = {}, -- not ready yet
		-- 		enable_on = {
		-- 			"html",
		-- 		}, -- set the file types you want the plugin to work on
		-- 		file_extensions = { "css", "sass", "less" }, -- set the local filetypes from which you want to derive classes
		-- 		style_sheets = {
		-- 			-- example of remote styles, only css no js for now
		-- 			"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
		-- 			"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css",
		-- 		},
		-- 		-- your configuration here
		-- 	},
		-- },
	},

	-- show source name in completion menu
	formatting = cmp_format,

	-- add borders to completion menu
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Make the first item in completion menu always be selected
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
})

-- friendly-snippets - extend snippet groups
require("luasnip").filetype_extend("c", { "cdoc" })
require("luasnip").filetype_extend("cpp", { "cppdoc" })

-----------------------------------------
-- https://github.com/ray-x/go.nvim
-----------------------------------------
require("go").setup()

-- Run gofmt + goimport on save
-- local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		require("go.format").goimport()
-- 	end,
-- 	group = format_sync_grp,
-- })

-------------------------------------------------
--- https://github.com/Jezda1337/nvim-html-css
-------------------------------------------------

-------------------------------------------------
--- https://github.com/windwp/nvim-ts-autotag
-------------------------------------------------
require("nvim-ts-autotag").setup()
