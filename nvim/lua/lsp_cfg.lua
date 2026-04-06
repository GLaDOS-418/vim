-----------------------------------------
---  LSP CONFIG
-----------------------------------------

-- Native LSP completion capabilities.
-- Why this exists:
--   - nvim-cmp advertises extra completion features to language servers.
--   - without this, LSP completion still works, but it is less capable.
-- ref:
--   - https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply shared defaults to every server, then override per-server below.
-- This keeps the common path small now that lsp-zero is gone.
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- Shared formatting helper for both the LSP attach map and the global alias.
-- Why conform instead of raw vim.lsp.buf.format():
--   - some filetypes already use formatter chaining/fallback rules here.
--   - this keeps <F3> and <leader>lf aligned.
local format_with_conform = function()
	require("conform").format({
		timeout_ms = 1000,
		async = false,
		lsp_fallback = true,
	})
end

-- Stop all LSP clients attached to one buffer.
--   - built-in `:LspStop` is not always exposed in this setup/runtime.
--   - this gives me one stable command I can remember.
--   - use `client:stop()` here; `vim.lsp.stop_client()` is deprecated.
local stop_lsp_for_buffer = function(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if vim.tbl_isempty(clients) then
		vim.notify("No LSP clients attached to this buffer.", vim.log.levels.INFO)
		return false
	end

	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
		client:stop()
	end

	vim.notify("Stopped LSP for this buffer: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
	return true
end

-- Restart all LSP clients for one buffer by stopping them, then re-editing.
-- Why `:edit`:
--   - LSP servers are enabled from the normal lspconfig/Mason path.
--   - reopening the buffer is enough to trigger attach again.
local restart_lsp_for_buffer = function(bufnr)
	if stop_lsp_for_buffer(bufnr) then
		vim.cmd("edit")
	end
end

-----------------------------------------
---  LSP COMMAND HELPERS
-----------------------------------------

-- To add new commands:
--   - keep these buffer-scoped unless there is a real need for a global action
--   - put the real logic in a Lua helper above, then expose a tiny command here
vim.api.nvim_create_user_command("LspBufStop", function()
	stop_lsp_for_buffer(0)
end, { desc = "Stop LSP clients attached to the current buffer" })

vim.api.nvim_create_user_command("LspBufRestart", function()
	restart_lsp_for_buffer(0)
end, { desc = "Restart LSP clients attached to the current buffer" })

-- Buffer-local LSP maps.
-- Called from the native `LspAttach` event so mappings only exist when a
-- language server is actually attached to the buffer.
local attach_lsp_keymaps = function(bufnr)
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
	vim.keymap.set({ "n", "x" }, "<F3>", format_with_conform, opts)

	-- Inlay hints
	-- Why disabled by default:
	--   - they are useful on demand, but too noisy as an always-on default.
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
end


-- required later during formatter/linter auto setup
local lsp_augroup = vim.api.nvim_create_augroup("Lsp", { clear = true })

-- Native attach hook replaces the old lsp-zero on_attach callback.
-- How to add something new:
--   - add new buffer-local LSP mappings inside `attach_lsp_keymaps()`
--   - add new attach-time behavior in this autocmd callback if it truly depends
--     on an active client
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function(args)
		attach_lsp_keymaps(args.buf)
	end,
})

-----------------------------------------
---  INSTALL  LSP SERVERS
-----------------------------------------

-- Install and auto-enable LSP servers through Mason.
-- find names for servers at:
-- https://mason-registry.dev/registry/list
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
-- How to add a new server:
--   1. add its lspconfig name to `ensure_installed`
--   2. if it needs custom behavior, add a `vim.lsp.config("<name>", {...})`
--      block in the setup section below
--   3. if it should stay installed but NOT auto-start, add it to
--      `automatic_enable.exclude`
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
	automatic_enable = {
		-- Java usually wants a dedicated jdtls flow, so keep Mason installs but
		-- do not auto-enable it from the generic path.
		exclude = {
			"jdtls",
		},
	},
})

-----------------------------------------
---  SETUP LSP SERVERS
-----------------------------------------

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- How to add a custom server config:
--   - use `vim.lsp.config("<server>", {...})`
--   - only add a block when the default Mason/native config is not enough
--   - keep shared defaults in `vim.lsp.config("*", ...)` above

-- clangd: extra flags for background indexing, clang-tidy, and richer header
-- completion behavior.
vim.lsp.config("clangd", {
	single_file_support = true,
	capabilities = capabilities,
	cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu" },
})

-- NOTE: disabled because mason installed stylua requires a GLIBC version that's ABI-incompatible with my system.
-- vim.lsp.enable('stylua')

-- lua_ls: teach the server about Neovim's runtime and avoid stomping over
-- project-local `.luarc.json` / `.luarc.jsonc` files when they already exist.
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (LuaJIT since it's Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
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

-----------------------------------------
---  INSTALL FORMATTERS & LINTERS
-----------------------------------------

-- Non-LSP tools managed through Mason.
-- How to add something new:
--   - add the Mason package name to `ensure_installed`
--   - if it formats code, wire it into conform below
--   - if it lints code, wire it into nvim-lint below
require("mason-tool-installer").setup({
	ensure_installed = {
		-- "stylua",
		-- "luacheck",

		"golines",
		"goimports-reviser",
		"gofumpt",
		"gomodifytags",
		"gotests",
		"golangci-lint",

		--"clang-format", " there's some issue during mason's installation and it was getting stuck.
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
		-- lua = { "stylua" },
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
	stop_after_first = true,
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

-- Diagnostic signs.
-- Why configure this explicitly:
--   - native vim.diagnostic replaced lsp-zero's sign helper
--   - keeping the icons here preserves the old visual language
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
})

-----------------------------------------
---  COMPLETION/SNNIPPETS
-----------------------------------------

--- ************************
--- COMPLETION FORMAT
--- ************************

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Completion popup formatting.
-- What this does:
--   - keeps symbol/icon, label, and source aligned in readable columns
--   - trims noisy signature text from the right-hand menu
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

-- https://github.com/zbirenbaum/copilot.lua
require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<C-j>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	panel = { enabled = true },
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
})

-- Setup CopilotChat for model selection
require("CopilotChat").setup({
	debug = false, -- Enable debugging
	-- See Configuration section for rest
	model = 'gemini-2.5-pro', -- default model
	mappings = {
		reset = {
			normal = '<leader>ccr',
			insert = '<C-l>'
		},
	},
	-- Custom prompts
	prompts = {
		Explain = "Please explain how the following code works.",
		Review = "Please review the following code and provide suggestions for improvement.",
		Tests = "Please explain how the selected code works, then generate unit tests for it.",
		Refactor = "Please refactor the following code to improve its clarity and readability.",
	},
})

-- Copilot model selection keymaps
vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<cr>', { desc = 'Open Copilot panel' })
vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<cr>', { desc = 'Open Copilot Chat' })
vim.keymap.set('v', '<leader>cc', '<cmd>CopilotChatVisual<cr>', { desc = 'Open Copilot Chat with selection' })
vim.keymap.set('n', '<leader>cm', function()
	-- Model switching command
	vim.ui.input({ prompt = 'Enter model (gpt-4, claude-3.5-sonnet, etc.): ' }, function(input)
		if input and input ~= '' then
			vim.cmd('CopilotChatModel ' .. input)
			vim.notify('Switched Copilot model to: ' .. input)
		end
	end)
end, { desc = 'Switch Copilot model' })

--- ************************
--- COMPLETION SOURCES
--- ************************

-- Skip some heavier completion sources for very large files.
-- Why:
--   - completion latency matters more than extra sources once files get big
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
-- How to add a new source:
--   - add it to this table
--   - give it a menu label in `cmp_format` above if you want it to show cleanly
local default_cmp_sources = cmp.config.sources({

	{ name = "nvim_lsp" },
	{ name = "nvim_lua" }, -- hrsh7th/cmp-nvim-lua
	{ name = "buffer" }, -- hrsh7th/cmp-buffer
	{ name = "emoji" }, -- hrsh7th/cmp-emoji
	{ name = "path" }, -- hrsh7th/cmp-path
	{ name = "luasnip" }, -- saadparwaiz1/cmp_luasnip
	{ name = "calc" }, -- hrsh7th/cmp-calc
	{ name = "git" }, -- petertriho/cmp-git
	{ name = "codecompanion" },
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
-- How to add a new snippet subgroup:
--   - register it in `nvim/snips/package.json`
--   - then extend the base filetype here, like cpp -> {"cppdoc", "gtest"}
require("luasnip").filetype_extend("c", { "cdoc" })
-- gtest stays a snippet group layered onto cpp; it is not a separate editor filetype.
require("luasnip").filetype_extend("cpp", { "cppdoc", "gtest" })

--- ************************
--- FINAL COMPLETION SETUP
--- ************************

cmp.setup({
	mapping = {
		["<c-space>"] = cmp.mapping.complete(),
		-- Super-tab behavior:
		--   1. move in cmp menu when it is open
		--   2. otherwise expand or jump through snippets
		--   3. otherwise fall back to literal <Tab>
		["<tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<s-tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
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
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
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
