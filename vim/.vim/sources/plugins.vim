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

if empty(glob('~/.vim/pack/vimspector/opt/vimspector')) && executable('git')
  silent !mkdir -p $HOME/.vim/pack
  silent !git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector
endif

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

Plug 'morhetz/gruvbox'                 " current colorscheme
Plug 'machakann/vim-highlightedyank'   " flash highlight yanked region
Plug 'tpope/vim-fugitive'              " handle git commands
Plug 'airblade/vim-gitgutter'          " see git diff in buffer
Plug 'tpope/vim-surround'              " surround text with tags
Plug 'godlygeek/tabular'               " text alignment
Plug 'itchyny/calendar.vim'            " crazy calendar plugin that can sync tasks
Plug 'sjl/gundo.vim'                   " see vim history-tree
Plug 'ctrlpvim/ctrlp.vim'              " fuzzy file search
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'ervandew/supertab'               " use tab for all insert mode completions
Plug 'majutsushi/tagbar'               " show tags in sidebar using ctags
Plug 'tpope/vim-abolish'

Plug 'scrooloose/vim-slumlord'         " inline previews for plantuml acitvity dia
Plug 'aklt/plantuml-syntax'            " syntax/linting for plantuml
Plug 'alvan/vim-closetag'              " to close markup lang tags

Plug 'vimwiki/vimwiki'                 " note taking in vim
Plug 'euclio/vim-markdown-composer',
  \{'do': function('BuildComposer')}   " async markdown live preview

" vimspector works better with vim rahter than nvim
" Plug 'puremourning/vimspector', " a debugging plugin for c++
"   \{ 'dir' : '~/.vim/pack/vimspector/opt/vimspector',
"   \  'do'  : './install_gadget.py --enable-c --enable-go --enable-python --enable-bash'}

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " asynchronous code completion
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ } " a LSP server for multiple languages, works with deoplete

" disabled on 25-April-2020
" Plug 'w0rp/ale'                         " asynchronous linting engine
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
  let g:gutentags_project_root = ['.root', '.git']
  let g:gutentags_modules = ['ctags' , 'gtags_cscope']
  let g:gutentags_define_advanced_commands = 1

" ale - plugin config {{{2
  nnoremap <silent> <C-k> <Plug>(ale_previous_wrap)
  nnoremap <silent> <C-j> <Plug>(ale_next_wrap)
  let g:ale_lint_on_text_changed = 0
  let g:ale_warn_about_trailing_whitespace = 0  " disable for python files
  let g:ale_warn_about_trailing_blank_lines = 0 " disable for python files


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


" tabular - plugin config {{{2
  if exists(":Tabularize")
    noremap <leader>a= :Tabularize /=<cr>
    noremap <leader>a" :Tabularize /"<cr>
    noremap <leader>a: :Tabularize /:<cr>
  endif


" ctrlp - plugin config {{{2
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_use_caching = 1
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
  let g:ctrlp_match_current_file = 1
  let g:ctrlp_working_path_mode = 'ra'          " pwd as current git root
  let g:ctrlp_root_markers = ['.root', '.git']          " add .root as project root
  let g:ctrlp_switch_buffer = 'E'               " jmp to file if already opened
  let g:ctrlp_match_window = 'bottom,order:ttb' " top-to-bottom filename matching
  let g:ctrlp_max_files = 0                     " set max files to enumerate as infinite
   if executable('rg')
     set grepprg=rg\ --color=never
     let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
   else
     augroup set_ignore
     au!
      "autocmd VimEnter * call WildignoreFromGitignore()
    augroup END
   endif

" fzf - plugin config {{{2
    let g:fzf_nvim_statusline = 0 " disable statusline overwriting
    nnoremap <silent> <c-p> :Files<CR>

" vim-markdown-composer - plugin config {{{2
  let g:markdown_composer_browser = '/usr/bin/firefox'
  let g:markdown_composer_open_browser = 1
  let g:markdown_composer_refresh_rate = 500 "ms
  let g:markdown_composer_autostart = 0


" YouCompleteMe - plugin config{{{2
  let g:ycm_enable_diagnostic_signs = 0                                 " only ale linting
  let g:ycm_enable_diagnostic_highlighting = 0                          " only ale linting
  let g:ycm_echo_current_diagnostic = 0                                 " only ale linting
  let g:ycm_key_list_select_completion = ['<down>','<c-j>']
  let g:ycm_key_list_previous_completion = ['<up>','<c-k>']
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'


" supertab - plugin config{{{2
  " mapped with down of YCM
  let g:SuperTabDefaultCompletionType = '<c-j>'


" ultisnips - plugin config{{{2
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-j>"
  let g:UltiSnipsJumpBackwardTrigger="<c-k>"


" tagbar - plugin config{{{2
  nnoremap <silent> <F8> :TagbarOpen fj<cr>

" vim spectre - plugin config {{{2
  let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
  packadd! vimspector

" deoplete - plugin config{{{2
  let g:deoplete#enable_at_startup = 1

" LanguageServerClient-neovim{{{2
  nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> <F12> :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'cpp': ['/usr/bin/clangd', '-std=c++17'],
    \ }
"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
