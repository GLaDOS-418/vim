" source vim configs
" https://dougblack.io/words/a-good-vimrc.html
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

" Misc --------------------------------------------------------
set nocompatible "be iMproverd, required
let mapleader=',' "leader is comma
" jk is escape
inoremap jk <ESC>
" <leader>k is move right one space
inoremap <leader>k <right>
set clipboard=unnamed "to use operating system clipboard

" Colors ------------------------------------------------------
set term=screen-256color "set teminal color to support 256 colors
colorscheme pablo
syntax enable " enable syntax processing

" Spaces and Tabs ---------------------------------------------
set autoindent
set smartindent
set expandtab " tabs are spaces
" set tabstop=4 " number of visual spaces per TAB
set shiftwidth=4
set softtabstop=4 " number of spaces in TAB when editing

" UI config ---------------------------------------------------
set number " show line numbers
set showcmd " shows last entered command in bottom right bar, not working
set cursorline " highlight current line

" toggle line numbers
nnoremap <leader>tn :set number!<CR>
nnoremap <leader>trn :set relativenumber!<CR>

filetype on "required
"filetype plugin indent on    " required
"filetype indent on " load filetype-specific indent files ~/.vim/indent/python.vim

set splitright
set splitbelow

"matching pair of braces
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

"matching pair of square brackets
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap []     []

"handling paranthesis
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

" "handling angular brackets
" inoremap <      <><Left>
" inoremap <<CR>  <<CR>><Esc>O
" inoremap <<     <
" inoremap <>     <>

set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when needed
set showmatch " highlight matching [{()}]

" Searching ---------------------------------------------------
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch " incremental search. search as chars are enetered
set hlsearch " highlight matches

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Folding -----------------------------------------------------
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " max 10 nested folds
" space open/closes folds in current block
nnoremap <space> za
" fold based on syntax. other values are: indent, marker, manual, expr, diff, syntax
set foldmethod=indent " no plugin for syntax yet.

" Movements --------------------------------------------------------
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to end/beginning of line(normal mode)
nnoremap E $
nnoremap B ^

" move to end/beginning of line(visual mode)
vnoremap E $
vnoremap B ^

" $/^ doesn't do anything(normal mode)
nnoremap $ <nop>
nnoremap ^ <nop>

" $/^ doesn't do anything(visual mode)
vnoremap $ <nop>
vnoremap ^ <nop>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Leader Shortcuts --------------------------------------------

" edit/load vimrc/bashrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session. Don't understand right now!! hence commented
" nnoremap <leader>s :mksession<CR>

" Plugins -----------------------------------------------------
" gundo
" ctrlP
" ag
" ycm
" ultisnips


" Custom functions --------------------------------------------

