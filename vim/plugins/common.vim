" contents -
"   - VISUAL
"   - SOURCE CONTROL
"   - NAVIGATION
"   - ARCHITECTURE & NOTES
"   - EDITING UTILS
"   - NON-EDITING UTILS

"------------------------------------------------------------
" VISUAL {{{1
"------------------------------------------------------------

Plug 'lifepillar/vim-gruvbox8'       " a better gruvbox for the shared core
Plug 'ryanoasis/vim-devicons'        " icon support for Vim; nvim also uses web-devicons
Plug 'machakann/vim-highlightedyank' " flash highlight yanked region

"------------------------------------------------------------
" SOURCE CONTROL {{{1
"------------------------------------------------------------

Plug 'tpope/vim-fugitive'   " handle git commands

" if has('nvim')
"   Plug 'lewis6991/gitsigns.nvim'
"   Plug 'folke/trouble.nvim'          " pretty list for showing diagnostics
" endif
Plug 'airblade/vim-gitgutter' " shared git signs in both Vim and Neovim

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

Plug 'vim-scripts/LargeFile'          " handling largefiles in vim
Plug 'tpope/vim-eunuch'               " file modification commands

" if has('nvim')
"   Plug 'folke/flash.nvim'
" endif
Plug 'easymotion/vim-easymotion'      " better movements
Plug 'christoomey/vim-tmux-navigator' " navigate seamlessly between vim and tmux

"------------------------------------------------------------
" ARCHITECTURE & NOTES {{{1
"------------------------------------------------------------

Plug 'scrooloose/vim-slumlord' " inline previews for plantuml activity dia
Plug 'aklt/plantuml-syntax'    " plantuml syntax highlight

"------------------------------------------------------------
" EDITING UTILS {{{1
"------------------------------------------------------------

" Plug 'ervandew/supertab'             " use tab for all insert mode completions
Plug 'tpope/vim-surround'    " surround text with tags
Plug 'godlygeek/tabular'     " text alignment
Plug 'tpope/vim-speeddating' " incr/decr dates with <c-a> & <c-x>
Plug 'mbbill/undotree',      " gives a file changes tree
      \ {'on': 'UndotreeToggle'}

"------------------------------------------------------------
" NON-EDITING UTILS {{{1
"------------------------------------------------------------

Plug 'tpope/vim-abolish'   " working with word replacements
Plug 'tpope/vim-repeat'    " repeat vim commands, and not just the native ones
Plug 'airblade/vim-rooter' " changes the cwd to project root

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
