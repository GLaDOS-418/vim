" contents -
"   - PLUGIN MANGER
"   - PLUGIN SETTINGS

"------------------------------------------------------------
" PLUGIN MANAGER {{{1
"------------------------------------------------------------

" download vim-plug and install plugins if vim started without plug.
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" if empty(glob('~/.vim/pack/vimspector/opt/vimspector')) && executable('git')
"   silent !mkdir -p $HOME/.vim/pack
"   silent !git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector
" endif

" helper function to check for conditions and load plugins. Follow below pattern:
" Cond( condition1, Cond(condition2,Cond(condition3, {dictionary}) ) )
function! Cond(cond, ...) "{{{2
  let opts = get(a:000, 0, {})
  return (a:cond) ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" build function req for vim-markdown-composer
" cargo is rust package mangaer
function! BuildComposer(info) "{{{2
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
function! BuildYCM(info) "{{{2
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if has('python')||has('python3')
    if a:info.status == 'installed' || a:info.force
      " !./install.py --clang-completer --go-completer --rust-completer --java-completer --system-libclang --system-boost
      !python install.py --clang-completer --go-completer --rust-completer --java-completer
    endif
  else
    echom "you don't 've python support in vim to build YCM!!!"
  endif
endfunction
" }}}

function! HasPython()
  return has('python')||has('python3')
endfunction


" plug plugin setup. vim_home and sep in vimrc
call plug#begin(vim_home . sep . 'plugged')

" Automatically install plugins on startup.
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

" Visual {{{3
Plug 'lifepillar/vim-gruvbox8'         " a better gruvbox
Plug 'machakann/vim-highlightedyank'   " flash highlight yanked region


" Source Control {{{3
Plug 'tpope/vim-fugitive'              " handle git commands
Plug 'airblade/vim-gitgutter'          " see git diff in buffer


" Navigation {{{3
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree' |                     " open project drawer
    \ Plug 'Xuyuanp/nerdtree-git-plugin' |      " mark files/dirs according to their status in drawer
Plug 'easymotion/vim-easymotion'                " better movements


" Architecture & Notes {{{3
Plug 'scrooloose/vim-slumlord'         " inline previews for plantuml acitvity dia
Plug 'aklt/plantuml-syntax'            " syntax/linting for plantuml
Plug 'vimwiki/vimwiki'                 " note taking in vim
Plug 'euclio/vim-markdown-composer',
  \{'do': function('BuildComposer')}   " async markdown live preview


" Debug {{{3

if has('vim')
  " TODO : SET UP VIMSPECTOR
  " vimspector works better with vim rahter than nvim
  " a debugging plugin for c++
  " Plug 'puremourning/vimspector', {
  "    \  'do' : ':VimspectorUpdate'
  "    \ }
endif


" Code Completion {{{3

Plug 'neoclide/coc.nvim', {'branch': 'release',
     \ 'do': { -> coc#util#install()}} " Node based code completion engine with LSP support
Plug 'sheerun/vim-polyglot'            " collection of language packs for vim
Plug 'alvan/vim-closetag'              " to close markup lang tags


" Editing Utils {{{3

" Plug 'ervandew/supertab'             " use tab for all insert mode completions
Plug 'majutsushi/tagbar'               " show tags in sidebar using ctags
Plug 'tpope/vim-surround'              " surround text with tags
Plug 'godlygeek/tabular'               " text alignment
Plug 'tpope/vim-commentary'            " comments lines, paragraphs etc.
Plug 'tpope/vim-speeddating'           " incr/decr dates with <c-a> & <c-x>
Plug 'mbbill/undotree',                " gives a file changes tree
      \ {'on': 'UndotreeToggle'}

" Non-Editing Utils {{{3
Plug 'itchyny/calendar.vim'            " crazy calendar plugin that can sync tasks
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'                " repeat vim commands, and not just the native ones
Plug 'airblade/vim-rooter'
" Plug 'djoshea/vim-autoread'

" disabled on 25-April-2020
" Plug 'junegunn/rainbow_parentheses.vim' " match paranthesis pair colors
" Plug 'junegunn/goyo.vim'                " distraction free mode
" Plug 'ludovicchabant/vim-gutentags'
"   \ ,Cond(executable('ctags'),Cond(executable('gtags-cscope')))
" Plug 'skywind3000/gutentags_plus'
"   \ ,Cond(executable('ctags'),Cond(executable('gtags-cscope')))
" Plug 'Valloric/YouCompleteMe',
"   \ Cond(HasPython(),
"   \ {'do':function('BuildYCM'), 'for':[]})
"Plug 'sirver/ultisnips',
"  \ Cond(HasPython())

call plug#end()

"------------------------------------------------------------
" PLUGIN SETTINGS {{{1
"------------------------------------------------------------

" gutentags_plus {{{2
" generate datebases in my cache directory, prevent gtags files polluting my project
  let g:gutentags_cache_dir = expand('~/.cache/tags')
  let g:gutentags_project_root = ['.root', '.git', '.svn', '.hg' ]
  let g:gutentags_modules = ['ctags' , 'gtags_cscope']
  let g:gutentags_define_advanced_commands = 1

" gitgutter - plugin config {{{2
  set updatetime=1000                 "wait how much time to detect file update
  let g:gitgutter_max_signs = 500     "threshold upto which gitgutter shows sign
  let g:gitgutter_highlight_lines = 0
  nnoremap gn :GitGutterNextHunk<CR>
  nnoremap gp :GitGutterPrevHunk<CR>
  nnoremap <leader>hs :GitGutterStageHunk<CR>
  nnoremap <leader>hu :GitGutterUndoHunk<CR>
  nnoremap <leader>hp :GitGutterPreviewHunk<CR>
  nnoremap <leader>ggt :GitGutterToggle<cr>
  if exists('&signcolumn')  " vim 7.4.2201+
    set signcolumn=yes
  else
    let g:gitgutter_sign_column_always = 1
  endif

  let g:gitgutter_sign_added = '++'
  let g:gitgutter_sign_modified = '**'
  let g:gitgutter_sign_removed = '~~'
  let g:gitgutter_sign_removed_first_line = '^^'
  let g:gitgutter_sign_modified_removed = '*~'
  " highlight GitGutterAdd    guifg=#009900 guibg=#009900 ctermfg=2 ctermbg=2
  " highlight GitGutterChange guifg=#bbbb00 guibg=#bbbb00 ctermfg=3 ctermbg=3
  " highlight GitGutterDelete guifg=#ff2222 guibg=#ff2222 ctermfg=1 ctermbg=1


" vim-closetag - plugin config {{{2
  let g:closetag_filenames = '*.xml,*.xslt,*.htm,*.html,*.xhtml,*.phtml'
  let g:closetag_xhtml_filenames = '*.xslt,*.xhtml,*.jsx'
  let g:closetag_filetypes = 'html,xml,xhtml,phtml'
  let g:closetag_xhtml_filetypes = 'xslt,xhtml,jsx'
  let g:closetag_emptyTags_caseSensitive = 1
  let g:closetag_shortcut = '>'               " Shortcut for closing tags, default is '>'
  let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''


" vimwiki- plugin config {{{2
  let g:vimwiki_list = [{'path': '~/repos/personal_notes/', 'syntax': 'markdown', 'ext': '.md'},
                       \{'path': '~/repos/work_notes/',     'syntax': 'markdown', 'ext': '.md'},
                       \{'path': '~/repos/blog/', 'syntax': 'markdown', 'ext': '.md'},
                       \]
  let g:vimwiki_use_mouse = 1
  noremap glo :VimwikiChangeSymbolTo *<CR>
  noremap glO :VimwikiChangeSymbolInListTo *<CR>
  noremap gll :VimwikiChangeSymbolTo #<CR>
  noremap glL :VimwikiChangeSymbolInListTo #<CR>


" fzf - plugin config {{{2
    let g:fzf_nvim_statusline = 0 " disable statusline overwriting

    " https://rietta.com/blog/hide-gitignored-files-fzf-vim/
    " fzf file fuzzy search that respects .gitignore
    " If in git directory, show only files that are committed, staged, unstaged or untracked
    " else use regular :Files
    nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-i': 'split',
      \ 'ctrl-v': 'vsplit' }
    let g:fzf_tags_command = 'ctags -R'


" vim-markdown-composer - plugin config {{{2
  let g:markdown_composer_browser = '/usr/bin/firefox'
  let g:markdown_composer_open_browser = 1
  let g:markdown_composer_refresh_rate = 500 "ms
  let g:markdown_composer_autostart = 0


" supertab - plugin config{{{2
  let g:SuperTabDefaultCompletionType = '<c-j>'


" tagbar - plugin config{{{2
  nnoremap <silent> <F8> :TagbarOpen fj<cr>


" vimspector {{{2
if has('vim')
  let g:vimspector_enable_mappings = 'HUMAN' "  'VISUAL_STUDIO'
  let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB', 'vscode-go', 'vscode-java-debug', 'vscode-bash-debug' ]
endif


" Nerdtree {{{2

  let NERDTreeQuitOnOpen = 1 " close nerdtree on opening a file
  let NERDTreeMinimalUI  = 1

  noremap <leader>nt :NERDTreeToggleVCS<CR>

  let g:NERDTreeGitStatusIndicatorMapCustom = {
                  \ 'Modified'  :'✹',
                  \ 'Staged'    :'✚',
                  \ 'Untracked' :'✭',
                  \ 'Renamed'   :'➜',
                  \ 'Unmerged'  :'═',
                  \ 'Deleted'   :'✖',
                  \ 'Dirty'     :'✗',
                  \ 'Ignored'   :'☒',
                  \ 'Clean'     :'✔︎',
                  \ 'Unknown'   :'?',
                  \ }


  augroup nerdtree
    au!
    " Start NERDTree. If a file is specified, move the cursor to its window.
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
    " Exit Vim if NERDTree is the only window left.
    " autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    "     \ quit | endif
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * silent NERDTreeMirror
  augroup END


" vim-rooter {{{2
  let g:rooter_patterns = ['.git', '.hg', '.svn', '.root', 'Makefile', '*.sln', 'build/env.sh', '=src']
  let g:rooter_change_directory_for_non_project_files = 'current'
  let g:rooter_resolve_links = 1
  let g:rooter_cd_cmd = 'lcd'


" coc.nvim {{{2

  let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-cmake']

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: right now supertab uses tab so disabling the next two mappings
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " GoTo code navigation.
  nnoremap <silent> gd <Plug>(coc-definition)
  nnoremap <silent> gt <Plug>(coc-type-definition)
  nnoremap <silent> gi <Plug>(coc-implementation)
  nnoremap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Symbol renaming.
  nmap <leader>rr <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>cf  <Plug>(coc-format-selected)
  nmap <leader>cf  <Plug>(coc-format-selected)

  augroup coc
    au!
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END


" vim-easymotion {{{2

let g:EasyMotion_do_mapping  = 0 " Disable default mappings
let g:EasyMotion_smartcase   = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" line motions
nnoremap <Leader>h <Plug>(easymotion-linebackward)
nnoremap <Leader>j <Plug>(easymotion-j)
nnoremap <Leader>k <Plug>(easymotion-k)
nnoremap <Leader>l <Plug>(easymotion-lineforward)

" <leader>f{char} to move to {char}
nnoremap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

" Move to line
nnoremap <Leader>L <Plug>(easymotion-overwin-line)

" move to word
nnoremap <Leader><Leader>w <Plug>(easymotion-overwin-w)

" search word
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
