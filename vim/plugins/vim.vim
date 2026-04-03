" contents -
"   - NAVIGATION
"   - ARCHITECTURE & NOTES
"   - LSP SUPPORT
"   - EDITING UTILS
"   - DEBUGGING

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

Plug 'preservim/nerdtree'           " Vim-side tree. Neovim counterpart is neo-tree.
Plug 'Xuyuanp/nerdtree-git-plugin'  " mark files/dirs according to their status in drawer

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Vim-side fuzzy finder. Neovim counterpart is Telescope.
Plug 'junegunn/fzf.vim'

"------------------------------------------------------------
" ARCHITECTURE & NOTES {{{1
"------------------------------------------------------------

" vim-polyglot needs this variable before loading the script
" keeping it here keeps plugin-only knobs out of vimrc.
let g:polyglot_disabled = ['go', 'sensible']

Plug 'sheerun/vim-polyglot' " collection of language packs for vim
Plug 'alvan/vim-closetag'   " to close markup lang tags

"------------------------------------------------------------
" LSP SUPPORT {{{1
"------------------------------------------------------------

Plug 'neoclide/coc.nvim', {'branch': 'release',
      \ 'do': { -> coc#util#install()}} " NodeJS based with LSP support

"------------------------------------------------------------
" EDITING UTILS {{{1
"------------------------------------------------------------

Plug 'majutsushi/tagbar'    " show tags in sidebar using ctags. Neovim counterpart is aerial.nvim.
Plug 'tpope/vim-commentary' " comments lines, paragraphs etc.

"------------------------------------------------------------
" DEBUGGING {{{1
"------------------------------------------------------------

" TODO : SET UP VIMSPECTOR FOR VIM
" Plug 'puremourning/vimspector', {
"    \  'do' : ':VimspectorUpdate'
"    \ }

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
