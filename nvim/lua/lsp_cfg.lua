-----------------------------------------
---  LSP CONFIG
-----------------------------------------

local zero = require("lsp-zero")

zero.on_attach(function(_, bufnr)
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
	vim.keymap.set({ "n", "x" }, "<F3>", function()
		require("conform").format({
			timeout_ms = 1000,
			async = false,
			lsp_fallback = true,
		})
	end, opts)

	-- Inlay hints
	vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) -- disabled by default

	vim.keymap.set("n", "<leader>lh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, opts)

	-- Hide inlay hints in insert mode, restore only if they were enabled
	local inlay_hints_were_enabled = false

	vim.api.nvim_create_autocmd("InsertEnter", {
		buffer = bufnr,
		callback = function()
			if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
				inlay_hints_were_enabled = true
				vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
			else
				inlay_hints_were_enabled = false
			end
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		buffer = bufnr,
		callback = function()
			if inlay_hints_were_enabled then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end,
	})

	----------------------------------------------------
	--- https://github.com/p00f/clangd_extensions.nvim
	----------------------------------------------------
	vim.keymap.set("n", "<leader>k", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
	vim.keymap.set("n", "<leader>th", "<cmd>ClangdTypeHierarchy<cr>", opts)
end)


-- required later during formatter/linter auto setup
local lsp_augroup = vim.api.nvim_create_augroup("Lsp", { clear = true })

-----------------------------------------
---  INSTALL  LSP SERVERS
-----------------------------------------

-- find names for servers at:
-- https://mason-registry.dev/registry/list
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
-- NOTE: don't add earthlyls. It hangs on certain Earthfile.
--- To check what LSP server is active on current file run
--- :lua print(vim.inspect(vim.lsp.get_active_clients()))

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd", -- cpp
		"cmake", -- cmake
		"rust_analyzer", -- rust
		"gopls", -- go
		"jdtls", -- java
		"lua_ls", -- lua
		"html", -- html
		"cssls", -- css
		"jqls", -- json
		"bashls", -- bash
		"pylsp", -- python
	},
	handlers = {
		zero.default_setup,
		jdtls = zero.noop,
	},
})

-----------------------------------------
---  SETUP LSP SERVERS
-----------------------------------------

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup(zero.nvim_lua_ls()) -- provides vim globals in lua
lspconfig.clangd.setup({
	single_file_support = true,
	capabilities = capabilities,
	cmd = { "clangd", "--background-index", "--clang-tidy" },
})

-- require("sonarlint").setup({
-- 	server = {
-- 		cmd = {
-- 			"sonarlint-language-server",
-- 			-- Ensure that sonarlint-language-server uses stdio channel
-- 			"-stdio",
-- 		},
-- 	},
-- 	filetypes = {
-- 		-- Tested and working
-- 		"cs",
-- 		"dockerfile",
-- 		"python",
-- 		"cpp",
-- 		"java",
-- 	},
-- })

-- default setup of servers
-- do I need this after mason-lspconfig/handlers ?
-- lsp_zero.setup_servers({'rust_analyzer', 'gopls'})

-----------------------------------------
---  INSTALL FORMATTERS & LINTERS
-----------------------------------------
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		-- "luacheck",

		"golines",
		"goimports-reviser",
		"gofumpt",
		"gomodifytags",
		"gotests",
		"golangci-lint",

		"clang-format",
		"cpplint",
		-- "cmake-format", -- not sure about the name

		-- "htmlbeautifier",
		"prettierd",
		"jq",

		-- "codespell",
		"bash-language-server",
		"shellcheck",
		"shellharden",
	},
})

-----------------------------------------
---  FORMATTING
-----------------------------------------
require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		tpp = { "clang_format" },
		cmake = { "cmake_format" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		html = { "htmlbeautifier" },
		json = { "jq" }, -- clang_format can be used alternatively

		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },

		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
		go = { "golines", "goimports-reviser", "gofumpt" },
		yaml = { "yamlfmt" },

		-- "*" filetype to run formatters on all filetypes.
		["*"] = { "codespell" },

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
-- NOTE: breaks for std::ranges in cpp. use format mapping to manually format.
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = lsp_augroup,
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })

-----------------------------------------
---  LINTING
-----------------------------------------

-- mfussenegger/nvim-lint
local lint = require("lint")

lint.linters_by_ft = {
	-- c = { "cpplint" },
	-- cpp = { "cpplint" },
	-- go = { "golangci-lint" },
	-- lua = { "luacheck" },
	bash = { "shellcheck", "shellharden" },
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
zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "H",
	info = "»",
})

-----------------------------------------
---  COMPLETION/SNNIPPETS
-----------------------------------------

--- ************************
--- COMPLETION FORMAT
--- ************************

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
-- local cmp_format = require("lsp-zero").cmp_format({
local cmp_format = {
	fields = { "kind", "abbr", "menu" },
	format = function(entry, item)
		local kind = require("lspkind").cmp_format({
			mode = "symbol_text", -- show only symbol annotations
			maxwidth = 50,
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
			menu = {
				nvim_lsp = "[LSP]",
				nvim_lua = "[LUA]",
				buffer = "[BUF]",
				emoji = "[EMO]",
				path = "[PATH]",
				luasnip = "[SNIP]",
				calc = "[CALC]",
				nvim_lsp_signature_help = "[SIG]",
				look = "[LOOK]",
			},
		})(entry, item)

		local custom_menu_icon = {
			--NOTE: requires a nerdfont to be rendered
			calc = " 󰃬 Text",
		}

		if entry.source.name == "calc" then
			-- Get the custom icon for thesource and
			-- Replace the kind glyph with the custom icon
			kind.kind = custom_menu_icon.calc
		end

		-- get types on the left, and offset the menu
		local strings = vim.split(kind.kind, "%s", { trimempty = true })
		kind.kind = string.format("%-4s", (strings[1] or ""))

		-- padded at 13 chars because 'TypeParameter' is the longest item in lspkind (12c)
		local paddedKind = string.format("%-13s", " " .. (strings[2] or ""))
		kind.menu = kind.menu:sub(1, kind.menu:find("]")) -- remove function signature
		kind.menu = paddedKind .. string.format("%-8s", kind.menu)

		return kind
	end,
}

--------------------------
--- AI COMPLETION SETUP
--------------------------

-- read an environment variable using lua
-- Ref: https://github.com/olimorris/codecompanion.nvim/blob/57bc5689a64a15b12251a8cd3c28dddd0d52c0cc/minimal.lua#L4
vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

-- olimorris/codecompanion.nvim
-- Out of the box, the plugin supports completion with both nvim-cmp
-- TODO: Is this enough?
require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = "copilot",
		},
		inline = {
			adapter = "copilot",
		},
	},
	opts = {
		log_level = "DEBUG",
	},
})

--- ************************
--- COMPLETION SOURCES
--- ************************

local bufIsBig = function(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end

-- default sources for all buffers
-- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
local default_cmp_sources = cmp.config.sources({

	{ name = "nvim_lsp" },
	{ name = "nvim_lua" }, -- hrsh7th/cmp-nvim-lua
	{ name = "buffer" }, -- hrsh7th/cmp-buffer
	{ name = "emoji" }, -- hrsh7th/cmp-emoji
	{ name = "path" }, -- hrsh7th/cmp-path
	{ name = "luasnip" }, -- saadparwaiz1/cmp_luasnip
	{ name = "nvim_lsp_signature_help" }, -- hrsh7th/cmp-nvim-lsp-signature-help
	{ name = "calc" }, -- hrsh7th/cmp-calc
	{ name = "git" }, -- petertriho/cmp-git
	{
		name = "look",
		keyword_length = 2,
		option = {
			convert_case = true,
			loud = true,
			--dict = '/usr/share/dict/words'
		},
	},
})

-- If a file is too large, I don't want to add to it's cmp sources treesitter, see:
-- https://github.com/hrsh7th/nvim-cmp/issues/1522
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function(t)
		local sources = default_cmp_sources
		if not bufIsBig(t.buf) then
			sources[#sources + 1] = { name = "treesitter", group_index = 2 }
		end
		cmp.setup.buffer({
			sources = sources,
		})
	end,
})

--- ************************
--- SNIPPETS
--- ************************

-- shortcut to load personal lua snippets
-- vim.keymap.set("n", "<leader><leader>ls", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<cr>")

-- for friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.loaders.from_snipmate").lazy_load() -- load honza/vim-snippets into nvim-cmp

-- for custom snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })

-- friendly-snippets - extend snippet groups
require("luasnip").filetype_extend("c", { "cdoc" })
require("luasnip").filetype_extend("cpp", { "cppdoc" })

--- ************************
--- FINAL COMPLETION SETUP
--- ************************

cmp.setup({
	mapping = {
		["<c-space>"] = cmp.mapping.complete(),
		["<tab>"] = cmp_action.luasnip_supertab(),
		["<s-tab>"] = cmp_action.luasnip_shift_supertab(),
		["<cr>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false, -- do not insert first item on list on <cr>
		}),
		-- scroll up and down the documentation window
		["<c-u>"] = cmp.mapping.scroll_docs(-4),
		["<c-d>"] = cmp.mapping.scroll_docs(4),
	},

	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},

	-- completion sources
	sources = default_cmp_sources,

	-- show source name in completion menu
	formatting = cmp_format,

	-- add borders to completion menu
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
		completion = {
			--  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			col_offset = 3,
			side_padding = 2,
			scrollbar = true,
			scrolloff = 1,
			zindex = 1001,
			border = "rounded",
		},
	},

	-- Make the first item in completion menu always be selected
	-- preselect = "item",
	-- completion = {
	-- 	completeopt = "menu,menuone,noinsert",
	-- },
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			require("clangd_extensions.cmp_scores"), -- from p00f/clangd_extensions
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

-- TODO: setup git completion source
require("cmp_git").setup()

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
