" source vim configs ------------------------------------------
" 
" dougblack.io/words/a-good-vimrc.html
" realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" github.com/amix/vimrc/tree/master/vimrcs
" shapeshed.com/vim-netrw/

" Misc --------------------------------------------------------
set nocompatible "be iMproverd, required
let mapleader=',' "leader is comma
" jk is escape
inoremap jk <ESC>
set nostartofline               " Make j/k respect the columns

" <leader>k is move right one space
inoremap <leader>k <right>
set clipboard=unnamed "to use operating system clipboard

" ignore compiled files
set wildignore=*.o,*~,*.pyc,*.so,*.out,*.log
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set history=500  " set how many lines of history vim has to remember
set autoread " set the file to autoread when a file is changed from outside
set encoding=utf8 
set esckeys                     " Allow cursor keys in insert mode.
set novb "no beeps vb-visual bell

" Colors ------------------------------------------------------

if $COLORTERM == 'gnome-terminal'
  set term=screen-256color "set teminal color to support 256 colors
endif

try
  colorscheme desert
catch
endtry

set background=dark
syntax enable " enable syntax processing


" Spaces and Tabs ---------------------------------------------
set autoindent
set smartindent
set expandtab " tabs are spaces
" set tabstop=2 " number of visual spaces per TAB
set shiftwidth=2
set softtabstop=2 " number of spaces in TAB when editing


" UI config ---------------------------------------------------
set number " show line numbers
set showcmd " shows last entered command in bottom right bar, not working
set cursorline " highlight current line
set ruler

" toggle line numbers
nnoremap <leader>tn :set number!<CR>
nnoremap <leader>trn :set relativenumber!<CR>

" filetype on "required
filetype off "required
filetype plugin indent on    " required
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
set gdefault                " RegExp global by default
set magic                   " Enable extended regexes.

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
" visual selection is custom function. [see the section]
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Folding -----------------------------------------------------
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " max 10 nested folds
" space open/closes folds in current block
nnoremap <space> za
" fold based on syntax. other values are: indent, marker, manual, expr, diff, syntax
set foldmethod=marker " no plugin for syntax yet.


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

" save session. 
" nnoremap <leader>s :mksession<CR>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Plugins -----------------------------------------------------

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" Plugin 'ying17zi/vim-live-latex-preview'
" Plugin 'LaTeX-Box-Team/LaTeX-Box'
" gundo
" ctrlP
" ag
" ycm
" ultisnips


call vundle#end()            " required


" Auto commands  --------------------------------------------

au FileType tex nnoremap <buffer> <leader>t :!pdflatex % <CR>

" Custom functions --------------------------------------------

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


