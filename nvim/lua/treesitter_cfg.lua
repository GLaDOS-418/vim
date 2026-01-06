require("nvim-treesitter").setup({
	-- A list of parser names, or "all" which must be installed.
	ensure_installed = {
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
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer. ensure treesitter-cli is installed
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
