"------------------------------------------------------------
" CATEGORIES {{{
"------------------------------------------------------------

" SOURCES
" MISC
" COLORS
" SPACES AND TABS
" UI CONFIG
" SEARCHING
" MOVEMENTS
" LEADER SHORTCUTS
" AUTO COMMANDS

" }}}

"------------------------------------------------------------
" SOURCES {{{
"------------------------------------------------------------

source ~/.vim/sources/plugins.vim
source ~/.vim/sources/statusline.vim
source ~/.vim/sources/abbreviations.vim
source ~/.vim/sources/custom_functions.vim

" }}}


"------------------------------------------------------------
" MISC {{{
"------------------------------------------------------------

" set nocompatible              " commented: r/vim/wiki/vimrctips
let mapleader=','               " leader is comma
let maplocalleader="\<space>"   " localleader is space
set nostartofline               " Make j/k respect the columns
set clipboard=unnamedplus       " to use operating system clipboard
set clipboard+=unnamed          " to use operating system clipboard
set history=1000                " set how many lines of history vim has to remember
set autoread                    " set the file to autoread when a file is changed from outside
set encoding=utf-8              " set vim encoding to utf-8
set fileencoding=utf-8          " set vim encoding to utf-8
set esckeys                     " Allow cursor keys in insert mode.
set title                       " change the terminal's title
set spelllang=en                " 'en_gb' sets region to British English. 'en' for all regions
set noswapfile                  " stops vim from creating a .swp file
" set nobackup                  " no error when same file being edited by multiple vim sessions
set textwidth=0                 " no automatic linefeeds in insert mode
set wrap                        " word wrap the text(normal/visual)
set visualbell                  " don't beep
set noerrorbells                " don't beep
set colorcolumn=100             " highlight on col 100
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set diffopt+=vertical           " vim-fugitive vertical split on diff
"set mouse+=a                   " use mouse to place cursor and copy w/o line num
syntax enable                   " enable syntax processing

" clearing the t_vb variable deactivates flashing
set t_vb=

" stackoverflow.com/questions/21618614/vim-shows-garbage-characters
" set t_RV=
" github.com/vim/vim/issues/2538
" set t_RS=
" set t_SH=

" jk is escape
inoremap jk <ESC>

" an attempt to prevent one key press
noremap ; :
noremap : ;

" ignore compiled files
set wildignore=*.o,*~,*.pyc,*.so,*.out,*.log,*.aux,*.bak,*.swp,*.class
if has("win32") || has("win64")
    set wildignore+=*\.git\*
else
    set wildignore+=*/.git/*,*/.DS_Store,*/tmp/*
endif

"insert datetime in the format specified on <F9>
nnoremap <F9> "=strftime("%Y-%m-%d")<CR>P
inoremap <F9> <C-R>=strftime("%Y-%m-%d")<CR>

" spell check toggle
nnoremap <F6> :set spell!<cr>

" redraw buffer
noremap  <F5> :redraw!<CR>
inoremap <F5> :redraw!<CR>

" toggle mouse
nnoremap <F3> :call MouseToggle()<cr>

" vi.stackexchange.com/questions/2419/mapping-ctrls-does-not-work#2425
silent! !stty -a | grep '\( \|^\)ixon' 1>/dev/null 2>&1
let g:ix_at_startup = (v:shell_error == 0)

if g:ix_at_startup == 1
    silent! !stty -ixon
    augroup term_stty
      au!
      autocmd VimLeave * silent !stty ixon
    augroup END
endif


" }}}

"------------------------------------------------------------
" COLORS    {{{
"------------------------------------------------------------

set background=dark

try
  colorscheme gruvbox
catch
  colorscheme desert
endtry

" gruvbox - plugin config
let g:gruvbox_contrast_dark='soft'

" user highlight group colors
hi! User1 ctermfg=black ctermbg=yellow cterm=bold guifg=black guibg=yellow gui=bold
hi! User2 ctermfg=black ctermbg=green  cterm=bold guifg=black guibg=green  gui=bold
hi! User3 ctermfg=black ctermbg=cyan   cterm=bold guifg=black guibg=cyan   gui=bold
hi! User4 ctermfg=white ctermbg=blue   cterm=bold guifg=white guibg=blue   gui=bold
hi! User5 ctermfg=white ctermbg=red    cterm=bold guifg=white guibg=red    gui=bold
hi! User6 ctermfg=black ctermbg=white  cterm=bold guifg=black guibg=white  gui=bold

" }}}

"------------------------------------------------------------
" SPACES AND TABS  {{{
"------------------------------------------------------------

set autoindent
set cindent           " better alternative to smartindent
set expandtab         " tabs are spaces
" set tabstop=2       " commented: r/vim/wiki/tabstop
set shiftwidth=2      " when (un)indenting lines shift with 1unit shiftwidth
set softtabstop=2     " number of spaces in TAB when editing
set pastetoggle=<F2>  " toggle insert(paste) mode

" handle jump markers
inoremap <space><tab> <esc>/<++><CR>:nohl<CR>"_c4l
inoremap <leader><space><tab> <++><esc>4h?<++><CR>:nohl<CR>"_c4l
nnoremap <space><tab><tab> :%s/<++>//g<CR>
inoremap <leader>m <++><esc>


" }}}

"------------------------------------------------------------
" UI CONFIG  {{{
"------------------------------------------------------------

set number          " show line numbers
"set relativenumber " show relative line number
set showcmd         " shows last entered command in bottom right bar, not working
set noshowmode      " don't show mode on last line
set cursorline      " highlight current line
set scrolloff=5     " minimum line offset to present on screen while scrolling.

" increase window size
nnoremap + <C-W>+
nnoremap > <C-W>>
" decrease window size
nnoremap - <C-W>-
nnoremap < <C-W><

" removed the below filetype plugin block as vim-plug handles it internally
" filetype on "required
" filetype plugin indent on    " required


"filetype indent on " load filetype-specific indent files ~/.vim/indent/python.vim

set splitright
set splitbelow

if has('gui_running')
  set guioptions-=T  " no toolbar
  set guioptions-=m  " no menubar
  set guioptions-=r  " no scrollbar
  set guioptions-=R  " no scrollbar
  set guioptions-=l  " no scrollbar
  set guioptions-=L  " no scrollbar

  " 0oO iIlL17 g9qGQcCuUsSEFBD ~-+ ,;:!|?%/== <<{{(([[]]))}}>> "'`
  if has("gui_gtk2") || has("gui_gtk3")
      set anti enc=utf-8
      set guifont=Source\ Code\ Pro\ Medium\ 12
  elseif has("gui_win32") || has("gui_win64" )
      set guifont=Source Code Pro:Medium:h12
  endif
endif


set wildmode=longest,list,full
set wildmenu    " visual autocomplete for command menu
set lazyredraw  " redraw only when needed
set showmatch   " highlight matching [{()}]

" }}}

"------------------------------------------------------------
" SEARCHING  {{{
"------------------------------------------------------------

set ignorecase    " use case insensitive search
set smartcase     " except when using capital letters
set incsearch     " incremental search. search as chars are enetered
set hlsearch      " highlight matches
set nogdefault    " don't set default 'g' flag during :s
set magic         " Enable extended regexes.

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
" visual selection is custom function. [see the section]
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" replace all
nnoremap S :%s//g<Left><Left>

" highlight last inserted text
" nnoremap gV `[v`]

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " max 10 nested folds
" space open/closes folds in current block
nnoremap <space> za

augroup ft_markers
  au!
  autocmd filetype cpp,c,js setlocal foldmethod=marker foldmarker={,}
  autocmd filetype python   setlocal foldmethod=indent
  autocmd filetype vim      setlocal foldmethod=marker foldmarker='{{{','}}}'
augroup END

" }}}

" }}}

"------------------------------------------------------------
" MOVEMENTS  {{{
"------------------------------------------------------------

" move vertically by visual line(normal/visual mode)
noremap j gj
noremap k gk

" move to end/beginning of line(normal/visual  mode)
noremap E $
noremap B ^

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" buffer movements and delete
nnoremap <c-f> :bn<cr>
nnoremap <c-b> :bp<cr>
nnoremap <c-q> :bd<cr>

" }}}

"------------------------------------------------------------
" LEADER SHORTCUTS  {{{
"------------------------------------------------------------

" toggle line numbers
nnoremap <leader>nn :set number!<CR>
nnoremap <leader>rn :set relativenumber!<CR>

" <leader>k is move right one space
inoremap <leader>k <right>

" edit/load vimrc/bashrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session.
" nnoremap <leader>s :mksession<CR>

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" remove trailing space in file
nnoremap <leader>ts :%s/\s\+$//ge<cr>
vnoremap <leader>ts :s/\s\+$//ge<cr>

" stage current file in git
nnoremap <leader>ga :!git add %<CR>

" spell check toggle
nnoremap <leader>s :set spell!<cr>

" paste in insert mode without auto-formatting
inoremap <leader>p <F2><esc>pa<F2>

" markdown style link paste from os clipboard
nnoremap <leader>l mk:read !curl --silent --location <C-R>=shellescape(@+)<cr> <bar> tr --delete '\n' <bar> grep -P '<title>.*<\/title>' <bar> sed -E -e 's@.*<title>[[:space:]]*(.*)[[:space:]]*</title>.*@\1@'<CR>i[<esc>A]( <C-R>+ )<esc>0v$h"zydd`k"zp

" get file name w/o ext
inoremap <leader>f <esc>mk:put =expand('%:t:r')<cr>v$hx`kpa

" }}}

"------------------------------------------------------------
" LEADER SHORTCUTS  {{{
"------------------------------------------------------------

" change pwd to root git dir
nnoremap <leader>gr :call CD_Git_Root()<cr>

" add wildignore filetypes from .gitignore
nnoremap <leader>cti :call WildignoreFromGitignore()<cr>

" toggle line numbers
nnoremap <leader>tn :set number!<CR>
nnoremap <leader>trn :set relativenumber!<CR>

" <leader>k is move right one space
inoremap <leader>k <right>

" edit/load vimrc/bashrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session.
" nnoremap <leader>s :mksession<CR>

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" stage current file in git
nnoremap <leader>ga :!git add %<CR>

" paste in insert mode without auto-formatting
inoremap <leader>p <F2><esc>pa<F2>

nnoremap gn :GitGutterNextHunk<CR>
nnoremap gp :GitGutterPrevHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>
nnoremap <leader>hp :GitGutterPreviewHunk<CR>

nnoremap <leader>ggt <esc>:GitGutterToggle<cr>

" }}}
"------------------------------------------------------------
" AUTO COMMANDS   {{{
"------------------------------------------------------------

" group au commands: so they won't be added when vimrc sourced again
augroup default_group
    " Remove all auto-commands from the group autogroup
    autocmd!

    " latex compilation shell commands. req: (pdf|xe)latex
    autocmd filetype tex nnoremap <buffer> <leader>t :!pdflatex % <CR>
    autocmd filetype tex nnoremap <buffer> <leader>x :!xelatex % <CR>

    autocmd BufNewFile,BufRead *.uml,*.pu,*.plantuml,.*puml set filetype=plantuml
    autocmd BufNewFile,BufRead *.md,*.mdown,*.markdown,.*mkd set filetype=markdown

    autocmd filetype cpp nnoremap <C-c> :w <bar> !clear && g++ -std=gnu++14 -g -D fio % -o %:p:h/%:t:r.out && time ./%:r.out<CR>
    autocmd filetype cpp inoremap <leader>e :%s/\(std::\)\?endl/"\\n"/<cr>
    autocmd filetype cpp inoremap <leader>io <esc>:r ~/.vim/personal_snips/cpp_fast_io.cpp<CR>i
    autocmd filetype cpp inoremap <leader>r <esc>:r ~/.vim/personal_snips/cpp_algo_start.cpp<CR>i
    autocmd filetype java nnoremap <C-c> :w <bar> !javac % && java -enableassertions %:p <CR>
    autocmd filetype python nnoremap <C-c> :w <bar> !python % <CR>
    autocmd filetype plantuml nnoremap <C-c> :call BuildUml() <cr>

    autocmd FocusLost * :silent! wall          " Save on lost focus
    autocmd VimResized * :wincmd = " Resize splits when the window is resized
augroup END

" }}}

"------------------------------------------------------------
" END
"------------------------------------------------------------
