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
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" helper function to check for conditions and load plugins
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
      !./install.py --clang-completer --rust-completer --go-completer --rust-completer --java-completer
    endif
  else
    echom "you don't 've python support in vim to build YCM!!!"
  endif
endfunction
" }}}

" plug plugin setup.
call plug#begin('~/.vim/plugged')

" Automatically install plugins on startup.
" if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
"   autocmd VimEnter * PlugInstall | q
" endif

Plug 'morhetz/gruvbox'                  " current colorscheme
Plug 'junegunn/rainbow_parentheses.vim' " match paranthesis pair colors

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

"------------------------------------------------------------
" PLUGIN SETTINGS {{{1
"------------------------------------------------------------

" ale - plugin config {{{2
  nnoremap <silent> <localleader>k <Plug>(ale_previous_wrap)
  nnoremap <silent> <localleader>j <Plug>(ale_next_wrap)
  let g:ale_lint_on_text_changed = 0
  let g:ale_warn_about_trailing_whitespace = 0  " disable for python files
  let g:ale_warn_about_trailing_blank_lines = 0 " disable for python files


" gitgutter - plugin config {{{2
  set updatetime=1000                 "wait how much time to detect file update
  let g:gitgutter_max_signs = 500     "threshold upto which gitgutter shows sign
  let g:gitgutter_highlight_lines = 1
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


" vim-closetag - plugin config {{{2
  let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
  let g:closetag_xhtml_filenames = '*.xslt,*.xml,*.xhtml,*.jsx'
  let g:closetag_emptyTags_caseSensitive = 1
  let g:closetag_shortcut = '>'               " Shortcut for closing tags, default is '>'
  let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''


" vimwiki- plugin config {{{2
  let g:vimwiki_list = [{'path': '~/repos/personal_notes/', 'syntax': 'markdown', 'ext': '.md'},
                       \{'path': '~/repos/work_notes/',     'syntax': 'markdown', 'ext': '.md'},
                       \]
  let g:vimwiki_use_mouse = 1


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
  let g:ctrlp_root_markers = ['.root']          " add .root as project root
  let g:ctrlp_switch_buffer = 'E'               " jmp to file if already opened
  let g:ctrlp_match_window = 'bottom,order:ttb' " top-to-bottom filename matching
  if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  else
    augroup set_ignore
    au!
     autocmd VimEnter * call WildignoreFromGitignore()
   augroup END
  endif


" vim-markdown-composer - plugin config {{{2
  let g:markdown_composer_browser = '/usr/bin/firefox'
  let g:markdown_composer_open_browser = 1
  let g:markdown_composer_refresh_rate = 500 "ms
  let g:markdown_composer_autostart = 0


" YouCompleteMe - plugin config{{{2
  let g:ycm_enable_diagnostic_signs = 0                                 " only ale linting
  let g:ycm_enable_diagnostic_highlighting = 0                          " only ale linting
  let g:ycm_echo_current_diagnostic = 0                                 " only ale linting
  let g:ycm_key_list_select_completion = ['<down>','<c-n>']
  let g:ycm_key_list_previous_completion = ['<up>','<c-p>']
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'


" supertab - plugin config{{{2
  " mapped with down of YCM
  let g:SuperTabDefaultCompletionType = '<c-n>'


" ultisnips - plugin config{{{2
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-j>"
  let g:UltiSnipsJumpBackwardTrigger="<c-k>"


" tagbar - plugin config{{{2
  nnoremap <silent> <F8> :TagbarOpen fj<cr>

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
