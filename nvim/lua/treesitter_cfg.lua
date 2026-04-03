local treesitter = require("nvim-treesitter")
local has_treesitter_cli = vim.fn.executable("tree-sitter") == 1

-- A list of parser names that I want available in Neovim.
local ensured_parsers = {
	"bash",
	"c",
	"c_sharp",
	"cmake",
	"comment",
	"cpp",
	"css",
	"dockerfile",
	"doxygen",
	"earthfile",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"java",
	"javadoc",
	"javascript",
	"lua",
	"luadoc",
	"make",
	"markdown",
	"markdown_inline",
	"rust",
	"sql",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

-- Newer nvim-treesitter separates setup from parser installation.
treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local installed_parsers = treesitter.get_installed("parsers")
local missing_parsers = vim.tbl_filter(function(parser_name)
	return not vim.list_contains(installed_parsers, parser_name)
end, ensured_parsers)

-- Kick off parser installs in the background so parser-dependent plugins
-- like neogen do not stay broken forever on a fresh machine.
-- The newer installer requires the external `tree-sitter` CLI, so skip
-- the auto install attempt when the binary is not available.
if has_treesitter_cli and #missing_parsers > 0 then
	treesitter.install(missing_parsers)
end
