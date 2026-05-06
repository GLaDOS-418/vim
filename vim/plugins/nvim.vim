" contents -
"   - VISUAL
"   - SOURCE CONTROL
"   - NAVIGATION
"   - ARCHITECTURE & NOTES
"   - LSP SUPPORT
"   - SNIPPETS
"   - CODE FORMATTING
"   - CODE LINTING
"   - DEBUGGING
"   - AI TOOLS
"   - CODE VIEW
"   - EDITING UTILS
"   - NON-EDITING UTILS

"------------------------------------------------------------
" VISUAL {{{1
"------------------------------------------------------------

Plug 'dstein64/vim-startuptime' " measure startup time
" Plug 'Eandrju/cellular-automaton.nvim'  " fun
" Plug 'goolord/alpha-nvim'               " A startup page
Plug 'folke/noice.nvim'                  " floating command mode
" Plug 'rcarriga/nvim-notify'
Plug 'NvChad/nvim-colorizer.lua'         " highlight colors in neovim

" colorschemes
Plug 'rebelot/kanagawa.nvim'       " use kanagawa-dragon
Plug 'EdenEast/nightfox.nvim'      " use terafox
Plug 'rose-pine/neovim'
Plug 'projekt0n/github-nvim-theme' " use github_dark_colorblind

" Plug 'eldad/nvim-devdocs'  " devdocs integration. unofficial fork of 'luckasRanarison/nvim-devdocs'
Plug 'girishji/devdocs.vim'  " still Vimscript, but only enabled in the Neovim UI flow

Plug 'stevearc/dressing.nvim' " UI hooks in nvim for input
Plug 'RRethy/vim-illuminate'  " highlight all instances of word under cursor

" interface for github.com/tree-sitter/tree-sitter
" TODO: add auto installation of treesitter servers
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser generator

"------------------------------------------------------------
" SOURCE CONTROL {{{1
"------------------------------------------------------------

Plug 'sindrets/diffview.nvim' " Neovim-only diff UI on top of git history

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

Plug 'nvim-neo-tree/neo-tree.nvim'  " Neovim-side tree. Vim counterpart is NERDTree.
Plug 'MunifTanjim/nui.nvim'

Plug 'stevearc/oil.nvim' " edit filesystem like buffer

Plug 'nvim-telescope/telescope.nvim' " Neovim-side fuzzy finder. Vim counterpart is fzf.vim.
Plug 'nvim-lua/plenary.nvim'

" Telescope Extensions
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'

Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
Plug 'folke/todo-comments.nvim' " add and search todo comments in repo
" Plug 'sourcegraph/sg.nvim', { 'do': 'nvim -l build/init.lua' }

" https://github.com/tpope/vim-eunuch/issues/56
" SudoWrite doesn't work with eunuch due to a neovim limitation.
Plug 'lambdalisue/vim-suda'

"------------------------------------------------------------
" ARCHITECTURE & NOTES {{{1
"------------------------------------------------------------

Plug 'richardbizik/nvim-toc'         " create TOC for markdown files
Plug 'obsidian-nvim/obsidian.nvim'   " access obsidian from nvim

Plug 'MeanderingProgrammer/render-markdown.nvim'

"------------------------------------------------------------
" LSP SUPPORT {{{1
"------------------------------------------------------------

Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate' }  " install LSP servers
Plug 'williamboman/mason-lspconfig.nvim'                 " bridge between lspconfig and mason
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'         " install third party tools
Plug 'neovim/nvim-lspconfig'                             " lspconfig
Plug 'https://gitlab.com/schrieveslaach/sonarlint.nvim'

"------------------------------------------------------------
" SNIPPETS {{{1
"------------------------------------------------------------

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Required. completion engine
Plug 'hrsh7th/nvim-cmp'                  " Required
Plug 'GLaDOS-418/friendly-snippets'      " fork of: 'rafamadriz/friendly-snippets'

" other snippets
Plug 'honza/vim-snippets'
Plug 'danymat/neogen' " generate annotations for your code

" find list of sources at:
" https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
Plug 'hrsh7th/cmp-nvim-lsp'                " Required
Plug 'hrsh7th/cmp-buffer'                  " nvim-cmp source for buffer words
Plug 'hrsh7th/cmp-nvim-lua'                " nvim-cmp source for neovim Lua API
Plug 'hrsh7th/cmp-emoji'                   " nvim-cmp source for emojis
Plug 'hrsh7th/cmp-path'                    " nvim-cmp source for filesystem paths
Plug 'hrsh7th/cmp-calc'                    " evaluate mathematical expressions
Plug 'petertriho/cmp-git'                  " git source for nvim-cmp
Plug 'octaltree/cmp-look'                  " source for linux 'look' tool
Plug 'saadparwaiz1/cmp_luasnip'

"------------------------------------------------------------
" CODE FORMATTING {{{1
"------------------------------------------------------------

Plug 'stevearc/conform.nvim'

Plug 'onsails/lspkind.nvim' " icons for snippet completion source
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-mini/mini.icons'

"------------------------------------------------------------
" CODE LINTING {{{1
"------------------------------------------------------------

Plug 'mfussenegger/nvim-lint'

"------------------------------------------------------------
" DEBUGGING {{{1
"------------------------------------------------------------

Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'           " required by dap-ui and other async helpers
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
" Plug 'jay-babu/mason-nvim-dap.nvim' " TODO: auto install dap servers

" language specific plugins {{{2

" cpp
Plug 'Civitasv/cmake-tools.nvim'
Plug 'p00f/clangd_extensions.nvim'

" golang
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua' " required with go.nvim
Plug 'leoluz/nvim-dap-go'

" java
Plug 'mfussenegger/nvim-jdtls'

" html/css
" Plug 'Jezda1337/nvim-html-css'  " TODO: external script completion setup
Plug 'windwp/nvim-ts-autotag'

" terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

"------------------------------------------------------------
" AI TOOLS {{{1
"------------------------------------------------------------

Plug 'copilotlsp-nvim/copilot-lsp'
Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'olimorris/codecompanion.nvim' " AI completion

"------------------------------------------------------------
" CODE VIEW {{{1
"------------------------------------------------------------

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'HampusHauffman/block.nvim'

"------------------------------------------------------------
" EDITING UTILS {{{1
"------------------------------------------------------------

Plug 'numToStr/Comment.nvim'
Plug 'stevearc/aerial.nvim' " alternative to majutsushi/tagbar
Plug 'Bekaboo/dropbar.nvim' " breadcrumbs
" Plug 'SmiteshP/nvim-navic'   " TODO: check dropbar vs nvim-navic

Plug 'kevinhwang91/nvim-ufo'          " set up code folding
Plug 'nicolas-martin/region-folding.nvim' " region folding
Plug 'kevinhwang91/promise-async'     " required for nvim-ufo

"------------------------------------------------------------
" NON-EDITING UTILS {{{1
"------------------------------------------------------------

Plug 'stevearc/resession.nvim'

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
