local M = {}

-- Small safety wrapper around :Neogen.
-- Why this exists:
--   - Neogen eventually calls `vim.treesitter.get_parser()` and throws when the
--     current buffer language parser is missing.
--   - Newer `nvim-treesitter` also requires the external `tree-sitter` CLI to
--     install parsers, so a blind `:Neogen` call can fail noisily.
-- This module keeps `<leader>n` user-friendly by checking those prerequisites
-- before delegating to the actual `:Neogen` command.
-- refs:
--   - ~/.vim/plugged/neogen/lua/neogen/generator.lua
--   - ~/.vim/plugged/nvim-treesitter/README.md

-- Resolve the parser name Neogen needs for the current buffer filetype.
local function current_parser_name()
	-- Map the current filetype to the tree-sitter parser name that Neogen needs.
	-- Most filetypes match directly, but using the language helper keeps the
	-- wrapper correct for filetypes that alias to a different parser name.
	local filetype = vim.bo.filetype
	if filetype == nil or filetype == "" then
		return nil
	end

	local ok, parser_name = pcall(vim.treesitter.language.get_lang, filetype)
	if ok and parser_name and parser_name ~= "" then
		return parser_name
	end

	return filetype
end

-- Check whether the required parser is already installed locally.
local function parser_is_installed(parser_name)
	-- Check the parser registry first so we can fail gracefully before Neogen
	-- reaches its deeper tree-sitter call stack.
	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok then
		return false
	end

	local installed = treesitter.get_installed("parsers")
	return vim.list_contains(installed, parser_name)
end

-- Detect whether the external tree-sitter CLI is available for parser installs.
local function has_treesitter_cli()
	-- Newer nvim-treesitter shells out to the external `tree-sitter` binary when
	-- compiling parsers, so we gate install attempts on that dependency.
	return vim.fn.executable("tree-sitter") == 1
end

-- Kick off an async parser install when Neogen is blocked on a missing parser.
local function install_parser(parser_name)
	-- Start an async parser install when possible; the caller shows the follow-up
	-- message instead of assuming the parser is immediately ready.
	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok then
		return false
	end

	local install_ok = pcall(treesitter.install, { parser_name })
	return install_ok
end

-- Main user-facing entry point for <leader>n. It guards prerequisites and then
-- delegates to Neogen's default generation flow.
function M.run()
	-- Entry point used by the <leader>n mapping in vim/plugins/nvim_settings.vim.
	local parser_name = current_parser_name()
	if parser_name == nil then
		vim.notify("Neogen needs a filetype before it can generate annotations.", vim.log.levels.WARN)
		return
	end

	if not parser_is_installed(parser_name) then
		if not has_treesitter_cli() then
			-- Avoid noisy repeated installer failures when the machine is missing
			-- the required `tree-sitter` CLI binary.
			vim.notify(
				"Missing tree-sitter parser for " .. parser_name
					.. ". Install tree-sitter-cli first, then run :TSInstall "
					.. parser_name
					.. ".",
				vim.log.levels.ERROR
			)
			return
		end

		local started_install = install_parser(parser_name)
		if started_install then
			-- Parser installs are async, so asking for a retry is more honest than
			-- pretending Neogen can run immediately.
			vim.notify(
				"Missing tree-sitter parser for " .. parser_name .. ". Started installation; retry <leader>n once it finishes.",
				vim.log.levels.WARN
			)
		else
			vim.notify(
				"Missing tree-sitter parser for " .. parser_name .. ". Run :TSInstall " .. parser_name .. " and retry <leader>n.",
				vim.log.levels.ERROR
			)
		end
		return
	end

	-- Happy path: prerequisites are in place, so hand off to Neogen itself.
	local ok, err = pcall(vim.cmd, "Neogen")
	if not ok then
		vim.notify(err, vim.log.levels.ERROR)
	end
end

return M
