"------------------------------------------------------------------------------
" SOURCE VIM CONFIGS 
"------------------------------------------------------------------------------

" dougblack.io/words/a-good-vimrc.html
" realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" witkowskibartosz.com/blog/gitgutter-vim-plugin.html
" github.com/amix/vimrc/tree/master/vimrcs

"------------------------------------------------------------------------------
" MISC 
"------------------------------------------------------------------------------

set nocompatible "be iMproverd, required
let mapleader=',' "leader is comma
" jk is escape
inoremap jk <ESC>
" <leader>k is move right one space
inoremap <leader>k <right>
set clipboard=unnamedplus "to use operating system clipboard

" ignore compiled files
set wildignore=*.o,*~.*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set history=500  " set how many lines of history vim has to remember
set autoread " set the file to autoread when a file is changed from outside
set encoding=utf8 

"------------------------------------------------------------------------------
" COLORS 
"------------------------------------------------------------------------------

if $COLORTERM == 'gnome-terminal'
  set term=screen-256color "set teminal color to support 256 colors
endif

try
  colorscheme desert
catch
endtry

set background=dark
syntax enable " enable syntax processing


"------------------------------------------------------------------------------
" SPACES AND TABS 
"------------------------------------------------------------------------------

set autoindent
set smartindent
set expandtab " tabs are spaces
" set tabstop=2 " number of visual spaces per TAB
set shiftwidth=2
set softtabstop=2 " number of spaces in TAB when editing


"------------------------------------------------------------------------------
" UI CONFIG 
"------------------------------------------------------------------------------

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


"------------------------------------------------------------------------------
" SEARCHING 
"------------------------------------------------------------------------------

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch " incremental search. search as chars are enetered
set hlsearch " highlight matches

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
set foldmethod=syntax " no plugin for syntax yet.


"------------------------------------------------------------------------------
" MOVEMENTS 
"------------------------------------------------------------------------------

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


"------------------------------------------------------------------------------
" LEADER SHORTCUTS 
"------------------------------------------------------------------------------

" edit/load vimrc/bashrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session. 
" nnoremap <leader>s :mksession<CR>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" stage current file in git
nnoremap <leader>ga :!git add %<CR>

"------------------------------------------------------------------------------
" PLUGINS 
"------------------------------------------------------------------------------

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
" fugitive
Plugin 'airblade/vim-gitgutter'
" markdown
" indentmarkers
" syntastic
" vinegar
" airline

call vundle#end()            " required

" gitgutter
set updatetime=1000 "wait how much time to detect file update
let g:gitgutter_max_signs = 500 "threshold upto which gitgutter shows sign
let g:gitgutter_highlight_lines = 1

nmap hn <Plug>GitGutterNextHunk
nmap hp <Plug>GitGutterPrevHunk
nmap <leader>ha <Plug>GitGutterStageHunk
nmap <leader>hr <Plug>GitGutterUndoHunk
nmap <leader>hv <Plug>GitGutterPreviewHunk            

nnoremap <leader>ggt <esc>:GitGutterToggle<cr>

if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

"------------------------------------------------------------------------------
" AUTO COMMANDS  
"------------------------------------------------------------------------------

au FileType tex nnoremap <buffer> <leader>t :!pdflatex % <CR>
au FileType tex nnoremap <buffer> <leader>x :!xelatex % <CR>


"------------------------------------------------------------------------------
" CUSTOM FUNCTIONS
"------------------------------------------------------------------------------

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

"------------------------------------------------------------------------------
" END
"------------------------------------------------------------------------------
