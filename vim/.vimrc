"------------------------------------------------------------
" CATEGORIES {{{
"------------------------------------------------------------

" PLUGIN MANAGER
" MISC
" COLORS
" SPACES AND TABS
" UI CONFIG
" SOURCES
" SEARCHING
" MOVEMENTS
" LEADER SHORTCUTS
" PLUGIN SETTINGS
" AUTO COMMANDS

" }}}
"------------------------------------------------------------
" PLUGIN MANAGER {{{
"------------------------------------------------------------

" download vim-plug and install plugins if vim started without plug.
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" helper function to check for conditions and load plugins
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return (a:cond) ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" build function req for vim-markdown-composer
" cargo is rust package mangaer
function! BuildComposer(info)
  if executable('cargo')
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  else
    echom "you don't 've cargo installed to build previewer!!!"
  endif
endfunction

" post update hook to build YCM
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if has('python')||has('python3')
    if a:info.status == 'installed' || a:info.force
      !./install.py --clang-completer --rust-completer --go-completer --rust-completer --java-completer
    endif
  else
    echom "you don't 've python support in vim to build YCM!!!"
  endif
endfunction

" plug plugin setup.
call plug#begin('~/.vim/plugged')

" Automatically install plugins on startup.
" if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
"   autocmd VimEnter * PlugInstall | q
" endif

Plug 'morhetz/gruvbox'                 " current colorscheme

Plug 'tpope/vim-fugitive'              " handle git commands
Plug 'airblade/vim-gitgutter'          " see git diff in buffer
Plug 'tpope/vim-surround'              " surround text with tags
Plug 'junegunn/goyo.vim'               " distraction free mode
Plug 'godlygeek/tabular'               " text alignment
Plug 'itchyny/calendar.vim'            " crazy calendar plugin that can sync tasks
Plug 'sjl/gundo.vim'                   " see vim history-tree
Plug 'ctrlpvim/ctrlp.vim'              " fuzzy file search
Plug 'ervandew/supertab'               " use tab for all insert mode completions
Plug 'majutsushi/tagbar'               " show tags in sidebar using ctags

Plug 'Valloric/YouCompleteMe',
  \ {'do':function('BuildYCM'),
  \  'for':['c','cpp','python','rust']
  \ }                                  " code completion engine
Plug 'w0rp/ale'                        " asynchronous linting engine
Plug 'sirver/ultisnips'                " custom snippets
Plug 'scrooloose/vim-slumlord'         " inline previews for plantuml acitvity dia
Plug 'aklt/plantuml-syntax'            " syntax/linting for plantuml
Plug 'alvan/vim-closetag'              " to close markup lang tags

Plug 'vimwiki/vimwiki'                 " note taking in vim
Plug 'euclio/vim-markdown-composer',
  \{'do': function('BuildComposer')}   " async markdown live preview

" yuttie/comfortable-motion.vim
" vinegar
" netrw config

call plug#end()

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

" backslash key not working.
" home to pipe
inoremap OH \|
" end to backslash
inoremap OF \

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
" SOURCES {{{
"------------------------------------------------------------

source ~/.vim/sources/abbreviations.vim
source ~/.vim/sources/statusline.vim
source ~/.vim/sources/custom_functions.vim

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

" highlight last inserted text *not working
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

" $/^ doesn't do anything(normal/visual mode)
noremap $ <nop>
noremap ^ <nop>

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
" PLUGIN SETTINGS {{{
"------------------------------------------------------------

" ale - plugin config {{{
  nnoremap <silent> <localleader>k <Plug>(ale_previous_wrap)
  nnoremap <silent> <localleader>j <Plug>(ale_next_wrap)

  let g:ale_lint_on_text_changed = 0
  let g:ale_warn_about_trailing_whitespace = 0  " disable for python files
  let g:ale_warn_about_trailing_blank_lines = 0 " disable for python files
" }}}

" gitgutter - plugin config {{{
  set updatetime=1000                 "wait how much time to detect file update
  let g:gitgutter_max_signs = 500     "threshold upto which gitgutter shows sign
  let g:gitgutter_highlight_lines = 1

  nnoremap gn :GitGutterNextHunk<CR>
  nnoremap gp :GitGutterPrevHunk<CR>
  nnoremap <leader>hs :GitGutterStageHunk<CR>
  nnoremap <leader>hu :GitGutterUndoHunk<CR>
  nnoremap <leader>hp :GitGutterPreviewHunk<CR>

  nnoremap <leader>ggt <esc>:GitGutterToggle<cr>

  if exists('&signcolumn')  " vim 7.4.2201+
    set signcolumn=yes
  else
    let g:gitgutter_sign_column_always = 1
  endif
"}}}

" vim-closetag - plugin config {{{
  let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
  let g:closetag_xhtml_filenames = '*.xslt,*.xml,*.xhtml,*.jsx'
  let g:closetag_emptyTags_caseSensitive = 1
  let g:closetag_shortcut = '>'               " Shortcut for closing tags, default is '>'
  let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''
"}}}

" vimwiki- plugin config {{{
  let g:vimwiki_list = [{'path': '~/repos/personal_notes/', 'syntax': 'markdown', 'ext': '.md'},
                       \{'path': '~/repos/work_notes/',     'syntax': 'markdown', 'ext': '.md'},
                       \]

let g:vimwiki_use_mouse = 1

"}}}

" tabular - plugin config {{{

if exists(":Tabularize")
  noremap <leader>a= :Tabularize /=<cr>
  noremap <leader>a" :Tabularize /"<cr>
  noremap <leader>a: :Tabularize /:<cr>
endif

" }}}

" ctrlp - plugin config {{{

  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP Git_Repo_Cdup()'
  let g:ctrlp_use_caching = 1
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
  let g:ctrlp_match_current_file = 1
  let g:ctrlp_working_path_mode = 'ra'          " pwd as current git root
  let g:ctrlp_root_markers = ['.root']          " add .root as project root
  let g:ctrlp_switch_buffer = 'E'               " jmp to file if already opened
  let g:ctrlp_match_window = 'bottom,order:ttb' " top-to-bottom filename matching
  if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  endif

"}}}

" vim-markdown-composer - plugin config {{{

  let g:markdown_composer_browser = '/usr/bin/firefox'
  let g:markdown_composer_open_browser = 1
  let g:markdown_composer_refresh_rate = 500 "ms
  let g:markdown_composer_autostart = 0

" }}}

" YouCompleteMe - plugin config{{{
  let g:ycm_enable_diagnostic_signs = 0                                 " only ale linting
  let g:ycm_enable_diagnostic_highlighting = 0                          " only ale linting
  let g:ycm_echo_current_diagnostic = 0                                 " only ale linting
  let g:ycm_key_list_select_completion = ['<down>','<c-n>']
  let g:ycm_key_list_previous_completion = ['<up>','<c-p>']
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
" }}}

" supertab - plugin config{{{
  " mapped with down of YCM
  let g:SuperTabDefaultCompletionType = '<c-n>'
" }}}
          
" ultisnips - plugin config{{{
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-j>"
  let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" tagbar - plugin config{{{
  nnoremap <F8> :TagbarOpen fj<cr>
" }}}

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
