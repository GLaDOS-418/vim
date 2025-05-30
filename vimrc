"------------------------------------------------------------
" PRE-CONFIG {{{1
"------------------------------------------------------------

" leaders before loading any plugin otherwise they remain vim
" default and doesn't work with these bindings
let mapleader      = " "    " leader is a global mapping
let maplocalleader = ","    " localleader is for buffer local commands


" vim-polyglot needs this variable before loading the script
let g:polyglot_disabled = ['go', 'sensible']

" required earlier for nvim-colorizer.lus
"Use 24-bit (true-color) mode in Vim/Neovim (if inside tmux, it should be version 2.2 or later)
" https://gist.github.com/weimeng23/60b51b30eb758bd7a2a648436da1e562
if has("nvim")
  "For Neovim 0.1.3 and 0.1.4
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799
if has("termguicolors")
  set termguicolors
  set t_Co=256
endif

if has('win32') ||  has('win64')
  let g:sep = '\'
  let g:vim_home = fnamemodify(expand("$MYVIMRC"), ":p:h") . sep . 'vimfiles'
else
  let g:sep = '/'
  let g:vim_home = fnamemodify(expand("$MYVIMRC"), ":p:h") . sep . '.vim'
endif

function! SourceFileName(fsep, ...)
   return join(a:000, a:fsep)
endfunction

let source_file_names=['plugins', 'statusline', 'abbreviations', 'custom_functions', 'environment']

for file_name in  source_file_names
  exe 'source ' . SourceFileName(sep, vim_home, 'sources', file_name . '.vim')
endfor

" " to maintain interoperability b/w diff OS, below can't be used
" source $HOME/vim/vim/.vim/sources/plugins.vim
" source $HOME/vim/vim/.vim/sources/statusline.vim
" source $HOME/vim/vim/.vim/sources/abbreviations.vim
" source $HOME/vim/vim/.vim/sources/custom_functions.vim
" source $HOME/vim/vim/.vim/sources/environment.vim
"------------------------------------------------------------
" MISC {{{1
"------------------------------------------------------------

" set nocompatible              " commented: r/vim/wiki/vimrctips
set hidden                      " allow moving around w/ saving the buffers
set nostartofline               " Make j/k respect the columns
set clipboard=unnamedplus       " to use operating system clipboard
set clipboard+=unnamed          " to use operating system clipboard
set history=1000                " set how many lines of history vim has to remember
set autoread                    " set the file to autoread when a file is changed from outside
" set autochdir                 " changed the cwd when vim opens a file/buffer
set encoding=utf-8              " set vim encoding to utf-8
set fileencoding=utf-8          " set vim encoding to utf-8
set title                       " change the terminal's title
set spelllang=en                " 'en_gb' sets region to British English. 'en' for all regions
set spell
set noswapfile                  " stops vim from creating a .swp file
set textwidth=0                 " no automatic linefeeds in insert mode
set nowrap                      " word wrap the text(normal/visual)
set visualbell                  " don't beep
set noerrorbells                " don't beep
set colorcolumn=120             " highlight on col 120
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set diffopt+=vertical           " vim-fugitive vertical split on diff
set viminfo='100,<1000,s10,h    " increases the memory limit from 50 lines to 1000 lines
set cmdheight=1                 " may give more space for displaying messages (default=1)
set updatetime=300              " slower update time leads to poor UX
syntax enable                   " enable syntax processing
"set mouse+=a                   " use mouse to place cursor and copy w/o line num
set shortmess+=c                " req for `coc.nvim` : github.com/neoclide/coc.nvim
set conceallevel=0              " check: https://github.com/epwalsh/obsidian.nvim/issues/286

if !has('nvim')
  set esckeys                   " Allow cursor keys in insert mode.
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear or gets resolved.
if has("nvim")
  set signcolumn=yes:1
elseif has("patch-8.1.1564")
  " merge signcolumn and number column into one
  set signcolumn=number
elseif exists('&signcolumn')  " vim 7.4.2201+
  set signcolumn=yes
endif

" https://github.com/neoclide/coc.nvim/issues/649#issuecomment-480086894
set nobackup                    " no error when same file being edited by multiple vim sessions
set nowritebackup               " don't write backup to a file
" set backupdir=~/.cache/backup " keep backup in this folder

" this augroup isn't req anymore but, still here for documentation purpose
" augroup backup
"   au!
"   " remove all old backups on vim start
"   au VimEnter * silent! execute '!rm ~/.cache/backup/*~ 2>/dev/null'
"   " make sure backup dir exists
"   au VimEnter * silent! execute '!mkdir ~/.cache/backup 2>/dev/null'
" augroup END

" clearing the t_vb variable deactivates flashing
set t_vb=

" stackoverflow.com/questions/21618614/vim-shows-garbage-characters
" set t_RV=
" github.com/vim/vim/issues/2538
" set t_RS=
" set t_SH=

" jk is escape. kj is accidental jk
inoremap jk <ESC>
inoremap kj <ESC>

" redo
nnoremap U <c-r>

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
" nnoremap <F9> "=strftime("%Y-%m-%d")<CR>P " normal mode mapping might be required for debugging
inoremap <F9> <C-R>=strftime("%Y-%m-%d")<CR>

" spell check toggle
nnoremap <leader>ss :set spell!<cr>

" redraw buffer
" noremap  <F5> :redraw!<CR>
" inoremap <F5> :redraw!<CR>

" toggle mouse
" nnoremap <F3> :call MouseToggle()<cr>

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


"------------------------------------------------------------
" COLORS    {{{1
"------------------------------------------------------------

set background=dark

try
  if has('nvim')
    " colorscheme terafox
    " colorscheme kanagawa-dragon
    colorscheme rose-pine

    " other schemes that I tried but didn't like
    " catppuccin, tokyonight, material
  else
    colorscheme gruvbox8

    " gruvbox - plugin config
    let g:gruvbox_contrast_dark='soft'
  endif
catch
  colorscheme desert
endtry

" user highlight group colors
hi! User1 ctermfg=black ctermbg=yellow cterm=bold guifg=black guibg=yellow gui=bold
hi! User2 ctermfg=black ctermbg=green  cterm=bold guifg=black guibg=green  gui=bold
hi! User3 ctermfg=black ctermbg=cyan   cterm=bold guifg=black guibg=cyan   gui=bold
hi! User4 ctermfg=white ctermbg=blue   cterm=bold guifg=white guibg=blue   gui=bold
hi! User5 ctermfg=white ctermbg=red    cterm=bold guifg=white guibg=red    gui=bold
hi! User6 ctermfg=black ctermbg=white  cterm=bold guifg=black guibg=white  gui=bold

" define colorschemes for vim and neovim
if has('nvim')
  let g:colorschemes = ['kanagawa-dragon', 'terafox', 'rose-pine', 'catppuccin']
else
  let g:colorschemes = ['gruvbox8']
endif

" cycle between colorschemes
nnoremap <c-c> :call CycleColorscheme()<CR>

"------------------------------------------------------------
" SPACES AND TABS  {{{1
"------------------------------------------------------------

set autoindent
set cindent           " better alternative to smartindent
set expandtab         " tabs are spaces
" set tabstop=2       " commented: r/vim/wiki/tabstop
set shiftwidth=4      " when (un)indenting lines shift with 1unit shiftwidth
set softtabstop=4     " number of spaces in TAB when editing

" TODO: does it need a keybinding?
" if !has('nvim')
"   set pastetoggle=<F6>  " toggle insert(paste) mode
" endif

" enable list mode to see tabs and spaces
set list

" strings to use in list mode
" set listchars=tab:▸\ ,eol:¬,lead:•,trail:·,extends:>,precedes:<,nbsp:_
set listchars=tab:▸\ ,lead:·,trail:·,extends:>,precedes:<,nbsp:_

" Remove the Windows ^M - when the encodings gets messed up
noremap <silent> <c-m> mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" indentation control in visual mode
vnoremap > >gv
vnoremap < <gv

"------------------------------------------------------------
" UI CONFIG  {{{1
"------------------------------------------------------------

set number          " show line numbers
set relativenumber " show relative line number
set showcmd         " shows last entered command in bottom right bar, not working
set noshowmode      " don't show mode on last line
set cursorline      " highlight current line
set scrolloff=8     " minimum line offset to present on screen while scrolling.

" increase window size
nnoremap + <C-W>+
nnoremap > <C-W>>

" decrease window size
nnoremap - <C-W>-
nnoremap < <C-W><

" commented the below filetype plugin block as vim-plug handles it internally
" filetype on "required
" filetype plugin indent on    " required


set splitright
set splitbelow

set wildmode=longest,list,full
set wildmenu    " visual autocomplete for command menu
set lazyredraw  " redraw only when needed
set showmatch   " highlight matching [{()}]

"------------------------------------------------------------
" FILE EXPLORER  {{{1
"------------------------------------------------------------

let g:netrw_liststyle = 3           " directory view - tree
let g:netrw_banner = 0              " remove the banner
let g:netrw_winsize = 25            " width of the explorer is 25% of the whole window
let g:netrw_browse_split = 4        " open files in a new window
let g:netrw_altv = 1                " open new file to the right of the project drawer
let g:netrw_list_hide = &wildignore " respect custom wildignore

" " launch netrw as soon as you enter vim
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

"------------------------------------------------------------
" SEARCHING  {{{1
"------------------------------------------------------------

set ignorecase    " use case insensitive search
set smartcase     " except when using capital letters
set incsearch     " incremental search. search as chars are entered
set hlsearch      " highlight matches
set nogdefault    " don't set default 'g' flag during :s
set magic         " Enable extended regexes.

" turn off search highlight
nnoremap <leader><leader> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
" visual selection is custom function. [see the section]
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" replace all
" nnoremap S :%s//g<Left><Left>

" normal modd <c-r> is redo, visual mode is replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" highlight last inserted text
" nnoremap gV `[v`]

" Folding {{{2
set foldnestmax=5       " max 5 nested folds
set foldminlines=2      " fold items where folded lines is more than this

if has('nvim')
  set foldenable                    " Disable folding at startup.
  set foldlevel=99 " Using ufo provider need a large value, feel free to decrease the value
  set foldlevelstart=99

  augroup ft_markers
    au!
    autocmd FileType vim setlocal foldmethod=marker
  augroup END

 
else
  set foldenable                      " Enable folding
  set foldlevelstart=5                " Open most folds by default

  augroup ft_markers
    au!
    autocmd filetype c,cpp,css,go,js,java,rust,sh,ts setlocal foldmethod=marker foldmarker={,}
    autocmd filetype python   setlocal foldmethod=indent
    autocmd filetype vim      setlocal foldmethod=marker
  augroup END
endif

" space open/closes folds in current block
nnoremap ff za

"------------------------------------------------------------
" MOVEMENTS  {{{1
"------------------------------------------------------------

" move vertically by visual line(normal/visual mode)
noremap j gj
noremap k gk

" move to end/beginning of line(normal/visual  mode)
noremap E $
noremap B ^

" split navigations
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
nnoremap <leader>rl <c-w>r
nnoremap <leader>rr <c-w>R

" buffer movements and delete
nnoremap <silent> <c-f> :bn<cr>
nnoremap <silent> <c-b> :bp<cr>
nnoremap <silent> <c-q> :bd<cr>

" cycle through tabs

" Go to last active tab 
augroup tabcycle
  autocmd!
  au TabLeave * let g:lasttab = tabpagenr()
augroup END

nnoremap <silent> T :exe "tabn ".g:lasttab<cr>
nnoremap H :tabprevious<CR>
nnoremap L :tabnext<CR>
nnoremap Q :tabclose<CR>


" move selections up or down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" join the line and move the cursor to the original position
nnoremap J mzJ`z

" move down/up and move the cursor to the centre of the buffer
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" move the cursor to next/prev match, centre the cursor and enter visual mode
nnoremap n nzzzv
nnoremap N Nzzzv


"------------------------------------------------------------
" LEADER SHORTCUTS  {{{1
"------------------------------------------------------------

" toggle line numbers
" nnoremap <silent> <leader>nn :set number!<CR>
" nnoremap <silent> <leader>rn :set relativenumber!<CR>

" edit/load vimrc
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

if has('vim')
  nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
else
  nnoremap <silent> <leader>sv :source $XDG_CONFIG_HOME/nvim/init.lua<CR>
endif

" save session.
" nnoremap <leader>s :mksession<CR>

" remove trailing space in file
nnoremap <silent> <leader>ts mmHmt:%s/\s\+$//ge<cr>'tzt'm
vnoremap <silent> <leader>ts :s/\s\+$//ge<cr>

" stage current file in git
" nnoremap <leader>ga :!git add %<CR>

" paste in insert mode without auto-formatting
if has('vim')
  inoremap <c-p> <esc><cmd>set paste<cr>p<cr><cmd>set nopaste<cr>a<cr>
  " nnoremap <leader>p <esc><cmd>set paste<cr>p<cr><cmd>set nopaste<cr>a<cr>
endif

" paste clipboard over the selection but, do not copy the current selection
vnoremap <leader>p "_dP

" paste a yanked line without changing the cursor position
nnoremap <silent> p :let save_col = col('.')<CR>p:call cursor(line('.'), save_col)<CR>
nnoremap <silent> P :let save_col = col('.')<CR>P:call cursor(line('.'), save_col)<CR>

" markdown style link paste from os clipboard
nnoremap <leader>ll mk:read !curl --silent --location <C-R>=shellescape(@+)<cr> <bar> tr --delete '\n' <bar> grep -oP "<title.*?>.*?<\/title>" <bar> head -n 1 <bar> sed -E -e "s@<title.*?>[[:space:]]*(.*?)[[:space:]]*</title>@\1@g" -e "s/[[:space:]]+/ /g"<CR>i[<esc>A]( <C-R>+ )<esc>0D`kPJ
inoremap :mlink: <esc>mk:read !curl --silent --location <C-R>=shellescape(@+)<cr> <bar> tr --delete '\n' <bar> grep -oP "<title.*?>.*?<\/title>" <bar> head -n 1 <bar> sed -E -e "s@<title.*?>[[:space:]]*(.*?)[[:space:]]*</title>@\1@g" -e "s/[[:space:]]+/ /g"<CR>i[<esc>A]( <C-R>+ )<esc>0D`kPJ

" get file name w/o ext
inoremap <c-f> <esc>mk:put =expand('%:t:r')<cr>v$hx`kpa

" change pwd to root git dir
nnoremap <leader>gg :call CD_Git_Root()<cr>

" add wildignore filetypes from .gitignore
nnoremap <leader>cti :call WildignoreFromGitignore()<cr>

" yank whole file
nnoremap <silent> <leader>yy :%y+<cr>

" code shopping
nnoremap <leader>op "Op<cr>
vnoremap <leader>oi "Oy<cr>
nnoremap <leader>oi "Oyy<cr>

" git merge using vimdiff
nnoremap <silent> <leader>gl <cmd>diffget LO<cr> " get LOCAL(TO)
nnoremap <silent> <leader>gb <cmd>diffget BA<cr> " get BASE(common ancestor of to & from)
nnoremap <silent> <leader>gr <cmd>diffget RE<cr> " get REMOTE(FROM)

"------------------------------------------------------------
" ENVIRONMENT PROFILES   {{{1
"------------------------------------------------------------

function! Cpp( )
    " refer below for 'gpp'
    " https://github.com/GLaDOS-418/dotfiles/blob/8ebc04ec054b8c109bc57e22a3864912edc19781/bash_functions#L28
    nnoremap <C-c> :w <bar> !gpp -Dfio % -o %:p:h/%:t:r.out && time ./%:r.out<cr>
    " inoremap <leader>io <esc>:r ~/.vim/personal_snips/cpp_fast_io.cpp<CR>i
    " inoremap <leader>r <esc>:r ~/.vim/personal_snips/cpp_algo_start.cpp<CR>i
    " nnoremap <c-s> :!kdbg <c-r>=expand("%:r:h") <cr>&<cr> " try to use LSP
endfunction

function! Rust( )
    nnoremap <C-c> :w <bar> !rustc % -o %:p:h/%:t:r && printf "\n" && time ./%:r<CR>
endfunction

function! Golang( )
    nnoremap <C-c> :w <bar> !time go run %<CR>
endfunction

function! Java( )
    nnoremap <C-c> :w <bar> !time javac %:p:h/%:t:r.java && java  -enableassertions %:t:r<CR>
endfunction

function! Latex( )
  " latex compilation shell commands. req: (pdf|xe)latex
  " nnoremap <buffer> <leader>t :!pdflatex % <CR>
  nnoremap <buffer> <C-c> :!xelatex % <CR>
endfunction

"------------------------------------------------------------
" AUTO COMMANDS   {{{1
"------------------------------------------------------------

" group au commands: so they won't be added when vimrc sourced again
augroup default_group
    " Remove all auto-commands from the group autogroup
    autocmd!

    " https://superuser.com/questions/815416/hitting-enter-in-the-quickfix-window-doesnt-work
    autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>

    autocmd BufNewFile,BufRead *.uml,*.pu,*.plantuml,.*puml set filetype=plantuml
    autocmd BufNewFile,BufRead *.md,*.mdown,*.markdown,.*mkd set filetype=markdown
    autocmd BufNewFile,BufRead *.tpp set filetype=cpp

    autocmd filetype go call Golang()
    autocmd filetype cpp call Cpp()
    autocmd filetype rust call Rust()
    autocmd filetype java call Java()
    autocmd filetype python nnoremap <C-c> :w <bar> !python % <CR>
    autocmd filetype plantuml nnoremap <C-c> :call BuildUml() <cr>
    autocmd filetype tex call Latex()

    " Set scripts to be executable from the shell
    autocmd BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod a+x <afile>" | endif | endif
    autocmd FocusLost,BufLeave,VimLeave * :silent! wall          " Save on lost focus
    autocmd VimResized * :wincmd = " Resize splits when the window is resized
    autocmd VimEnter * redraw!

    " https://stackoverflow.com/questions/2157914/can-vim-monitor-realtime-changes-to-a-file/48296697#48296697
    " needs low updatetime and autoread set. checks if file is changed on disk and reloads, doesn't if buffer is not saved
    " useful if you're using multiple editors e.g. vim for writing and vscode for debugging
    " for neovim, check this open issue : https://github.com/neovim/neovim/issues/1380
    " autocmd CursorHold *  checktime | call feedkeys("lh")

    " auto reload when vim config is modified
    autocmd! bufwritepost source $XDG_CONFIG_HOME/nvim/init.lua
    autocmd! bufwritepost source $MYVIMRC
augroup END

let g:gitroot =  Git_Repo_Cdup()
"vim build tags for project"
silent function! LoadTags( channel )
silent! execute "cs add " . g:gitroot . "GTAGS"
echo "GTAGS built and loaded"
endfunction

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
