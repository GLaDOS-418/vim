"------------------------------------------------------------
" CATEGORIES {{{
"------------------------------------------------------------

" PLUGIN MANAGER
" MISC
" COLORS
" SPACES AND TABS
" UI CONFIG
" STATUSLINE
" SEARCHING
" MOVEMENTS
" LEADER SHORTCUTS
" PLUGIN SETTINGS
" AUTO COMMANDS
" CUSTOM FUNCTIONS
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

" plug plugin setup.
call plug#begin('~/.vim/plugged')

" Automatically install missing plugins on startup. [commented to improve startup]
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

Plug 'tomasr/molokai'
Plug 'ajh17/Spacegray.vim'
Plug 'morhetz/gruvbox'          " currently in use

Plug 'xolox/vim-notes'| Plug 'xolox/vim-misc'

Plug 'tpope/vim-fugitive'       " to handle git commands
Plug 'airblade/vim-gitgutter'   " to see git diff

Plug 'alvan/vim-closetag'       " to close markup lang tags
Plug 'tpope/vim-surround'       " to surround text with tags

Plug 'mileszs/ack.vim'          " ag.vim is no longer maintained.
Plug 'sjl/gundo.vim'            " to see vim history-tree
" {{{ command-t when ruby support available else ctrlp
Plug 'wincent/command-t', has('ruby') ? {
    \ 'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
    \ }:{ 'on': [] }
" install 'the_silver_searcher for speeding up ack and ctrlp.
" github.com/ggreer/the_silver_searcher
Plug 'ctrlpvim/ctrlp.vim', has('ruby')?{'on':[]}:{}
" }}}

Plug 'w0rp/ale'                 " asynchronous linting engine
Plug 'scrooloose/vim-slumlord'  " inline previews for plantuml acitvity dia
Plug 'aklt/plantuml-syntax'     " syntax/linting for plantuml

" considerable plugins
" deoplete.nvim (async completion for nvim/vim8)(ycm alter)
" vimwiki (alternative of vim-notes)
" Plug 'ying17zi/vim-live-latex-preview'
" Plug 'LaTeX-Box-Team/LaTeX-Box'
" ultisnips
" markdown
" indentmarkers
" vinegar

call plug#end()

" }}}

"------------------------------------------------------------
" MISC {{{
"------------------------------------------------------------

" set nocompatible              " commented: r/vim/wiki/vimrctips
let mapleader=','               " leader is comma
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
set mouse+=a                    " use mouse to place cursor and copy w/o line num
syntax enable                   " enable syntax processing

" clearing the t_vb variable deactivates flashing
set t_vb=

" stackoverflow.com/questions/21618614/vim-shows-garbage-characters
" set t_RV=
" github.com/vim/vim/issues/2538
" set t_RS=
" set t_SH=

" jk/kj is escape
inoremap jk <ESC>
inoremap kj <ESC>

" an attempt to prevent one key press
noremap ; :
noremap : ;

" redraw buffer
noremap  <F5> :redraw!<CR>
inoremap <F5> :redraw!<CR>

" backslash key not working.
" home to pipe
noremap OH \|
inoremap OH \|
" end to backslash
noremap OF \
inoremap OF \

" ignore compiled files
set wildignore=*.o,*~,*.pyc,*.so,*.out,*.log,*.aux,*.bak,*.swp,*.class
if has("win16") || has("win32") || has("win64")
    set wildignore+=.git\*
else
    set wildignore+=*/.git/*,*/.DS_Store
endif

"insert datetime in the format specified on <F9>
nnoremap <F9> "=strftime("%Y-%m-%d")<CR>P
inoremap <F9> <C-R>=strftime("%Y-%m-%d")<CR>

" vi.stackexchange.com/questions/2419/mapping-ctrls-does-not-work#2425
silent! !stty -a | grep '\( \|^\)ixon' 1>/dev/null 2>&1
let g:ix_at_startup = (v:shell_error == 0)

if g:ix_at_startup == 1
    silent! !stty -ixon
    augroup reset_default
      au!
      autocmd VimLeave * silent !stty ixon
    augroup END
endif


" }}}

"------------------------------------------------------------
" COLORS    {{{
"------------------------------------------------------------

set background=dark

" :call ShowColorSchemeName() to show the current colorscheme that vim is using[custom fn]
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  " github.com/neovim/neovim/issues/7722
  " setting term blindly might be the issue with garbage rendering
  " was easily reproducibe using ctrl+i in vim 8.1
  " set term=screen-256color "set teminal color to support 256 colors
endif

try
  "colorscheme molokai
  "colorscheme spacegray
  colorscheme gruvbox
catch
  colorscheme desert
endtry


" molokai theme - plugin config
" let g:molokai_original=1


" spacegray theme - plugin config
" let g:spacegray_low_contrast = 1
" let g:spacegray_use_italics = 1
" let g:spacegray_underline_search = 1

" gruvbox - plugin config
let g:gruvbox_contrast_dark='soft'

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


" }}}

"------------------------------------------------------------
" UI CONFIG  {{{
"------------------------------------------------------------

set number          " show line numbers
set relativenumber  " show relative line number
set showcmd         " shows last entered command in bottom right bar, not working
set noshowmode      " don't show mode on last line
set cursorline      " highlight current line
set scrolloff=5     " minimum line offset to present on screen while scrolling.

" removed the below filetype plugin block as vim-plug handles it internally
" filetype on "required
" filetype plugin indent on    " required


"filetype indent on " load filetype-specific indent files ~/.vim/indent/python.vim

set splitright
set splitbelow

if has('gui_running')
  set guioptions-=T  " no toolbar
  set guioptions-=m  " no menubar
endif

"matching pair of braces
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
" inoremap {{     {
inoremap {}     {}

"matching pair of square brackets
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
" inoremap [[     [
inoremap []     []

"handling paranthesis
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
" inoremap ((     (
inoremap ()     ()

" "handling angular brackets
" inoremap <      <><Left>
" inoremap <<CR>  <<CR>><Esc>O
" inoremap <<     <
" inoremap <>     <>

set wildmode=longest,list,full
set wildmenu    " visual autocomplete for command menu
set lazyredraw  " redraw only when needed
set showmatch   " highlight matching [{()}]

"------------------------------------------------------------
" STATUSLINE {{{
"------------------------------------------------------------

set laststatus=2  " status line always enabled

let g:currentmode={
      \ 'n'  : ' Normal ',
      \ 'no' : ' N·Operator Pending ',
      \ 'v'  : ' Visual ',
      \ 'V'  : ' V·Line ',
      \ '^V' : ' V·Block ',
      \ 's'  : ' Select ',
      \ 'S'  : ' S·Line ',
      \ '^S' : ' S·Block ',
      \ 'i'  : ' Insert ',
      \ 'R'  : ' Replace ',
      \ 'Rv' : ' V·Replace ',
      \ 'c'  : ' Command ',
      \ 'cv' : ' Vim Ex ',
      \ 'ce' : ' Ex ',
      \ 'r'  : ' Prompt ',
      \ 'rm' : ' More ',
      \ 'r?' : ' Confirm ',
      \ '!'  : ' Shell ',
      \ 't'  : ' Terminal ' }

" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg=008'
  elseif (mode() =~# '\v(v|V)'
        \ || g:currentmode[mode()] ==# 'V·Block'
        \ || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg=005'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg=004'
  else
    exe 'hi! StatusLine ctermfg=006'
  endif

  return ''
endfunction

" Function: display errors from Ale in statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf(
  \ 'W:%d E:%d',
  \ l:all_non_errors,
  \ l:all_errors
  \)
endfunction

" Function: returns paste mode. (since insert behaves different in this mode)
function! PasteForStatusline() abort
    let paste_status = &paste
    if paste_status == 1
        return " [paste] "
    else
        return ""
    endif
endfunction

function! GitBranchFugitive() abort
  let branch=fugitive#head()
  if branch != ''
    return '  '.branch.' '
  else
    return ''
  endif
endfunction

" User colors for gui
hi User1 guifg=#ffdad8  guibg=#880c0e
hi User2 guifg=#000000  guibg=#F4905C
hi User3 guifg=#292b00  guibg=#f4f597
hi User4 guifg=#112605  guibg=#aefe7B
hi User5 guifg=#051d00  guibg=#7dcc7d
hi User7 guifg=#ffffff  guibg=#880c0e gui=bold
hi User8 guifg=#ffffff  guibg=#5b7fbb
hi User9 guifg=#ffffff  guibg=#810085
hi User0 guifg=#ffffff  guibg=#094afe

" General Format: %-0{minwid}.{maxwid}{item}
" Higlight Groups: #<format-name>#  -> see :help hl for more group names

function! ActiveStatus()
  " clear statusline
  let statusline=""

  " Changing the statusline color
  "let statusline+=%{ChangeStatuslineColor()}

  " truncate to left
  let statusline.="%<"

  " let hl group to : popup menu normal line
  let statusline.="%#PmenuSel#"

  " get git branch name[max width of 15]
  " github.com/fatih/vim-go/issues/71#issuecomment-394808485
  " let statusline.="%.15{GitBranch()}"
  let statusline.="%.15{GitBranchFugitive()}"

  " let hl group to : directory listing style
  let statusline.="%#WildMenu#"

  " file name
  let statusline.="\ %f"

  " read only flag
  let statusline.="%r"

  " switching to the right side
  let statusline.="%="

  " let hl group to : error message style
  let statusline.="%#ErrorMsg#"

  " show the error message from ALE plugin
  let statusline.="%{LinterStatus()}"

  let statusline.="%#LineNr#"

  " file type
  let statusline.="%y"

  let statusline.="[%{&fileencoding?&fileencoding:&encoding}]"
  " file format[unix/dos]
  let statusline.="[%{&fileformat}\]"

  " file position percentage
  let statusline.="\ %3p%%"

  let statusline.="%#ModeMsg#"

  " line[width-4ch, pad-left]:col[width-3ch, pad-right]
  let statusline.="\ %4l:%-3c"

  " switch back to normal statusline highlight
  let statusline.="%*"

  " number of lines in buffer[width-6ch, padding-left]
  let statusline.="\ %6L"

  let statusline.="%#ModeMsg#"
  " let statusline.=%#IncSearch#

  let statusline.="\%3{toupper(get(g:currentmode,strtrans(mode())))}"

  " paste mode flag
  let statusline.="%{PasteForStatusline()}"

  return statusline
endfunction

function! InactiveStatus()
  " clear statusline
  let statusline="%3*[I]"
  let statusline.=ActiveStatus()
  return statusline
endfunction

setlocal statusline=%!ActiveStatus()

augroup status
  autocmd!
  autocmd WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END

" }}}

"------------------------------------------------------------
" SEARCHING  {{{
"------------------------------------------------------------

set ignorecase    " use case insensitive search
set smartcase     " except when using capital letters
set incsearch     " incremental search. search as chars are enetered
set hlsearch      " highlight matches
set gdefault      " RegExp global by default
set magic         " Enable extended regexes.

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
" visual selection is custom function. [see the section]
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" highlight last inserted text *not working
" nnoremap gV `[v`]

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " max 10 nested folds
" space open/closes folds in current block
nnoremap <space> za
" foldmethod values: indent, marker, manual, expr, diff, syntax
set foldmethod=marker   " no plugin for syntax yet.
set foldmarker={,}

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
nnoremap <leader>l mk:read !curl --silent <C-R>+ <bar> grep -P '<title>.*<\/title>' <bar> sed -E -e 's@<title>(.*)</title>@\1@' -e 's/^[[:space:]]*//g'<CR>i[<esc>A]( <C-R>+ )<esc>0v$h"zydd`k"zp

" }}}

"------------------------------------------------------------
" PLUGIN SETTINGS {{{
"------------------------------------------------------------

" ale - plugin config {{{

let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'python': ['flake8']
  \ }

let g:ale_fixers = {
  \ 'javascript': ['prettier', 'eslint'],
  \ 'python': ['autopep8']
  \ }

let g:ale_sign_error = '>>'
let g:ale_sign_info = '--'
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'      " lint only when file saved
let g:ale_lint_on_enter = 0                   " don't run linters on opening a file
let g:ale_lint_on_filetype_changed = 1
let g:ale_completion_enabled = 0              " overrides omnicompletion if enabled
let g:ale_fix_on_save = 1                     " fix files when you save them.
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
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'               " Shortcut for closing tags, default is '>'
let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''
"}}}

"vim notes - plugin config {{{
let g:notes_directories = ['~/dotfiles/vim/notes']
let g:notes_list_bullets = ['*', '-', '+']
let g:notes_unicode_enabled = 0
" let g:notes_suffix = '.md'
let g:notes_title_sync='change-title'
vnoremap <leader>ns :NoteFromSelectedText<CR>
nnoremap <C-e> :edit note:
"}}}

" ack.vim - plugin config {{{
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column --heading --follow --smart-case'
  "search in pwd. [!] if not given, the first occurence is jumped to.
endif

nnoremap <leader>a :Ack!<space>

" }}}

"command-t - plugin config {{{

" change pwd to root git dir
nnoremap <leader>gr :call CD_Git_Root()<cr>
" add wildignore filetypes from .gitignore
nnoremap <leader>cti :call WildignoreFromGitignore()<cr>

if has('ruby')
  " open cmd-t window
  nnoremap <leader>t :CommandT<CR>
  nnoremap <leader>tp :CommandT
  " with ruby support use command-t
  " start command-t to find files in notes directory.
  nnoremap <leader>fn :CommandT /mnt/windows/projects/notes<cr>
else
  " with no ruby support in vim, use ctrl-p + ag(silver search for vim)
  let g:ctrlp_match_window = 'bottom,order:ttb'                  " top-to-bottom filename matching
  let g:ctrlp_switch_buffer = 0                                  " always open file in new buffer
  let g:ctrlp_working_path_mode = 0                              " ability to change pwd in vim session
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""' " use ag to search
endif

"}}}

" }}}

"------------------------------------------------------------
" LEADER SHORTCUTS  {{{
"------------------------------------------------------------

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

" spell check toggle
nnoremap <leader>s :set spell!<cr>

" paste in insert mode without auto-formatting
inoremap <leader>p <F2><esc>pa<F2>

" }}}


nnoremap gn :GitGutterNextHunk<CR>
nnoremap gp :GitGutterPrevHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>
nnoremap <leader>hp :GitGutterPreviewHunk<CR>

nnoremap <leader>ggt <esc>:GitGutterToggle<cr>

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

    autocmd filetype cpp nnoremap <C-c> :w <bar> !clear && g++ -std=gnu++14 -g -D fio -O2 % -o %:p:h/%:t:r.out && ./%:r.out<CR>
    autocmd filetype c nnoremap <C-c> :w <bar> !gcc -std=c99 -lm % -o %:p:h/%:t:r.out && ./%:r.out<CR>
    autocmd filetype java nnoremap <C-c> :w <bar> !javac % && java -enableassertions %:p <CR>
    autocmd filetype python nnoremap <C-c> :w <bar> !python % <CR>
    autocmd filetype go nnoremap <C-c> :w <bar> !go build % && ./%:p <CR>

    autocmd FocusLost * :silent! wall          " Save on lost focus
    autocmd VimResized * :wincmd = " Resize splits when the window is resized
augroup END

" }}}

"------------------------------------------------------------
" CUSTOM FUNCTIONS {{{
"------------------------------------------------------------


function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction


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


function! Git_Repo_Cdup() " Get the relative path to repo root
    "Ask git for the root of the git repo (as a relative '../../' path)
    let git_top = system('git rev-parse --show-cdup')
    let git_fail = 'fatal: Not a git repository'
    if strpart(git_top, 0, strlen(git_fail)) == git_fail
        " Above line says we are not in git repo. Ugly. Better version?
        return ''
    else
        " Return the cdup path to the root. If already in root,
        " path will be empty, so add './'
        return './' . git_top
    endif
endfunction

function! CD_Git_Root()
    execute 'cd '.Git_Repo_Cdup()
    let curdir = getcwd()
    echo 'CWD now set to: '.curdir
endfunction


" Define the wildignore from gitignore. Primarily for CommandT
function! WildignoreFromGitignore()
    silent call CD_Git_Root()
    let gitignore = '.gitignore'
    if filereadable(gitignore)
        let igstring = ''
        for oline in readfile(gitignore)
            let line = substitute(oline, '\s|\n|\r', '', "g")
            if line =~ '^#' | con | endif
            if line == '' | con  | endif
            if line =~ '^!' | con  | endif
            if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
            let igstring .= "," . line
        endfor
        let execstring = "set wildignore+=".substitute(igstring,'^,','',"g")
        execute execstring
        echo 'Wildignore defined from gitignore in: '.getcwd()
    else
        echo 'Unable to find gitignore'
    endif
endfunction

function! ShowColorSchemeName()
    try
        echo g:colors_name
    catch /^Vim:E121/
        echo "default
    endtry
endfunction

" }}}


"------------------------------------------------------------
" END
"------------------------------------------------------------
