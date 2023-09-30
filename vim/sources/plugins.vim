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

" helper function to check for conditions and load plugins. Follow below pattern:
" Cond( condition1, Cond(condition2,Cond(condition3, {dictionary}) ) )
function! Cond(cond, ...) "{{{2
  let opts = get(a:000, 0, {})
  return (a:cond) ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

function! HasPython()
  return has('python')||has('python3')
endfunction


" plug plugin setup. vim_home and sep in vimrc
call plug#begin(vim_home . sep . 'plugged')

" Automatically install plugins on startup.
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

" useless-but-fun {{{3
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'goolord/alpha-nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'

" Visual {{{3
"
if has('nvim')
" colorschemes
  Plug 'rebelot/kanagawa.nvim'    " use kanagawa-dragon
  Plug 'EdenEast/nightfox.nvim'   " use terafox

  Plug 'norcalli/nvim-colorizer.lua' " highlight colors in neovim
endif
Plug 'lifepillar/vim-gruvbox8'  " a better gruvbox


Plug 'ryanoasis/vim-devicons'           " icons for plugins

Plug 'machakann/vim-highlightedyank'    " flash highlight yanked region

if has('nvim')
  Plug 'luckasRanarison/nvim-devdocs'
  Plug 'stevearc/dressing.nvim'           " UI hooks in nvim for input
  Plug 'nvim-treesitter/nvim-treesitter', " interface for github.com/tree-sitter/tree-sitter
       \{'do': ':TSUpdate'}               "   it's a parser generator
endif


" Source Control {{{3
Plug 'tpope/vim-fugitive'              " handle git commands
Plug 'airblade/vim-gitgutter'          " see git diff in buffer


" Navigation {{{3
if has('nvim')
  Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'MunifTanjim/nui.nvim'

  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' } |
    \ Plug 'nvim-lua/plenary.nvim'

  Plug 'ThePrimeagen/harpoon'
  Plug 'chrisgrieser/nvim-genghis'            " vim-eunuch alternative for nvim
  Plug 'hrsh7th/cmp-omni'                     " required by nvim-genghis for autocompletion of directories

else
  Plug 'preservim/nerdtree' |                 " open project drawer
  \ Plug 'Xuyuanp/nerdtree-git-plugin'        " mark files/dirs according to their status in drawer

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-eunuch'               " file modification commands
endif


Plug 'easymotion/vim-easymotion'        " better movements
Plug 'christoomey/vim-tmux-navigator'   " navigate seamlessy between vim and tmux

" Architecture & Notes {{{3
Plug 'scrooloose/vim-slumlord'         " inline previews for plantuml acitvity dia
Plug 'aklt/plantuml-syntax'            " syntax/linting for plantuml


" Debug {{{3

" TODO : SET UP VIMSPECTOR FOR VIM
" vimspector works better with vim rahter than nvim
" use nvim-dap (better than vimspector) for neovim
" a debugging plugin for c++
" Plug 'puremourning/vimspector', {
"    \  'do' : ':VimspectorUpdate'
"    \ }

if has('nvim')
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'

  " language specific dap servers
  Plug 'leoluz/nvim-dap-go'
endif
"
" LSP Support {{{4

" Plug 'neoclide/coc.nvim', {'branch': 'release',
"      \ 'do': { -> coc#util#install()}} " Node based code completion engine with LSP support

if has('nvim')
  Plug 'williamboman/mason-lspconfig.nvim'               " Optional
  Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
  Plug 'neovim/nvim-lspconfig'                           " Required
  Plug 'hrsh7th/nvim-cmp'         " Required
  Plug 'hrsh7th/cmp-nvim-lsp'     " Required
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v1.*'}  " Required
  Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

  Plug 'jose-elias-alvarez/null-ls.nvim' " formatter/linter

  " breadcrumbs
  " jPlug 'nvimdev/lspsaga.nvim'
  Plug 'Bekaboo/dropbar.nvim'
endif

" Language Specific {{{3

" golang
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua' " recommended if need floating window support

" java
Plug 'mfussenegger/nvim-jdtls'

" snippets {{{6
if has('nvim')
  Plug 'MarcWeber/vim-addon-mw-utils' | 
    \ Plug 'tomtom/tlib_vim' |
    \ Plug 'garbas/vim-snipmate' |
    \ Plug 'honza/vim-snippets'
endif

Plug 'sheerun/vim-polyglot'            " collection of language packs for vim
Plug 'alvan/vim-closetag'              " to close markup lang tags

" Code View {{{3
" Plug 'neovim/nvim-lspconfig'
" Plug 'SmiteshP/nvim-navic'
Plug 'lukas-reineke/indent-blankline.nvim'

" Editing Utils {{{3

" Plug 'ervandew/supertab'             " use tab for all insert mode completions

" gtags-cscope support is removed in nvim 0.9+
" https://github.com/neovim/neovim/pull/20545
if has('nvim')
  Plug 'dhananjaylatkar/cscope_maps.nvim'
endif
Plug 'majutsushi/tagbar'               " show tags in sidebar using ctags
Plug 'tpope/vim-surround'              " surround text with tags
Plug 'godlygeek/tabular'               " text alignment
Plug 'tpope/vim-commentary'            " comments lines, paragraphs etc.
Plug 'tpope/vim-speeddating'           " incr/decr dates with <c-a> & <c-x>
Plug 'mbbill/undotree',                " gives a file changes tree
      \ {'on': 'UndotreeToggle'}

" Non-Editing Utils {{{3
if has('nvim')
  Plug 'stevearc/resession.nvim'
endif
Plug 'itchyny/calendar.vim'            " crazy calendar plugin that can sync tasks
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'                " repeat vim commands, and not just the native ones
Plug 'airblade/vim-rooter'

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
  if !exists('&signcolumn')  " < vim 7.4.2201+
    let g:gitgutter_sign_column_always = 1
  endif

  let g:gitgutter_sign_added = '│'
  let g:gitgutter_sign_modified = '│'
  let g:gitgutter_sign_removed = '_'
  let g:gitgutter_sign_removed_first_line = '-'
  let g:gitgutter_sign_modified_removed = '~'
  " let g:gitgutter_sign_added = '++'
  " let g:gitgutter_sign_modified = '**'
  " let g:gitgutter_sign_removed = '~~'
  " let g:gitgutter_sign_removed_first_line = '^^'
  " let g:gitgutter_sign_modified_removed = '*~'
  highlight GitGutterAdd    guifg=#009900 guibg=#009900 ctermfg=2 ctermbg=2
  highlight GitGutterChange guifg=#bbbb00 guibg=#bbbb00 ctermfg=3 ctermbg=3
  highlight GitGutterDelete guifg=#ff2222 guibg=#ff2222 ctermfg=1 ctermbg=1


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
    if has('vim')
      nnoremap <expr> <c-t> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
    endif

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
  let NERDTreeShowHidden = 1

  if has('vim')
    noremap <leader>d :NERDTreeToggleVCS<CR>
  endif

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
    " autocmd BufWinEnter * silent NERDTreeMirror
  augroup END


" vim-rooter {{{2
  let g:rooter_patterns = ['.git', '.hg', '.svn', '.root', 'Makefile', '*.sln', 'build/env.sh', '=src']
  let g:rooter_change_directory_for_non_project_files = 'current'
  let g:rooter_resolve_links = 1
  let g:rooter_cd_cmd = 'lcd'



" neotree {{{2

  if has('nvim')
    noremap <leader>d :Neotree toggle filesystem float<cr>
  endif


" coc.nvim {{{2
"
"  let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-cmake', 'coc-rust-analyzer']
"
"  " Use tab for trigger completion with characters ahead and navigate.
"  " NOTE: right now supertab uses tab so disabling the next two mappings
"  inoremap <silent><expr> <TAB>
"        \ pumvisible() ? "\<C-n>" :
"        \ <SID>check_back_space() ? "\<TAB>" :
"        \ coc#refresh()
"  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"  function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~# '\s'
"  endfunction
"
"  " Use <c-space> to trigger completion.
"  if has('nvim')
"    inoremap <silent><expr> <c-space> coc#refresh()
"  else
"    inoremap <silent><expr> <c-@> coc#refresh()
"  endif
"
"  " Make <CR> auto-select the first completion item and notify coc.nvim to
"  " format on enter, <cr> could be remapped by other vim plugin
"  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"  " GoTo code navigation.
"  nnoremap <silent> gd <Plug>(coc-definition)
"  nnoremap <silent> gt <Plug>(coc-type-definition)
"  nnoremap <silent> gi <Plug>(coc-implementation)
"  nnoremap <silent> gr <Plug>(coc-references)
"
"  " Use K to show documentation in preview window.
"  nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"  function! s:show_documentation()
"    if (index(['vim','help'], &filetype) >= 0)
"      execute 'h '.expand('<cword>')
"    elseif (coc#rpc#ready())
"      call CocActionAsync('doHover')
"    else
"      execute '!' . &keywordprg . " " . expand('<cword>')
"    endif
"  endfunction
"
"  " Symbol renaming.
"  nmap <leader>rr <Plug>(coc-rename)
"
"  " Formatting selected code.
"  xmap <leader>cf  <Plug>(coc-format-selected)
"  nmap <leader>cf  <Plug>(coc-format-selected)
"
"  augroup coc
"    au!
"    " Highlight the symbol and its references when holding the cursor.
"    autocmd CursorHold * silent call CocActionAsync('highlight')
"    " Update signature help on jump placeholder.
"    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"  augroup END



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
" nnoremap <Leader>f <Plug>(easymotion-overwin-f)

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


" indent-blankline {{{2

let g:show_current_context = 1
let g:show_current_context_start = 1
let g:space_char_blankline = " "
let g:show_current_context = 1
let g:show_current_context_start = 1


" undotree {{{2

if has("persistent_undo")
   let target_path = expand('~/.local/share/.vimundodir/')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

nnoremap <leader>u :UndotreeToggle<cr>

" vim-eunuch and nvim-genghis {{{2


"-----------------------------------------------------------
" LUA CONFIGS
"-----------------------------------------------------------

if has('nvim')

  lua require('lsp_cfg')
  lua require('nvim_dap')
  lua require('null_ls')
  lua require('mason_cfg')
  lua require('resession_cfg')
  lua require('neotree_cfg')
  lua require('misc')

  " telescope {{{2
  nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob=!.git/*,--smart-case<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep find_command=rg,--ignore,--hidden,--files,--glob=!.git/*,--smart-case<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader>fc <cmd>Telescope git_commits<cr>
  nnoremap <leader>fd <cmd>DevdocsOpenFloat<cr>

  " lsp-zero {{{2
  nnoremap <leader>lf <cmd>LspZeroFormat<cr>

  " harpoon {{{2
  nnoremap <c-m> <cmd>lua require("harpoon.mark").add_file()<cr>
  nnoremap <c-g> <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
  nnoremap <c-n> <cmd>lua require("harpoon.ui").nav_next()<cr>
  nnoremap <c-p> <cmd>lua require("harpoon.ui").nav_prev()<cr>

  let g:snipMate = { 'snippet_version' : 1 }

  " nvim-dap {{{2
  nnoremap <silent> <F6>  <cmd>lua require'dap'.toggle_breakpoint()<cr>
  nnoremap <silent> <F5>  <cmd>lua require'dap'.continue()<cr>
  nnoremap <silent> <F10> <cmd>lua require'dap'.step_over()<cr>
  nnoremap <silent> <F11> <cmd>lua require'dap'.step_into()<cr>
  nnoremap <silent> <F4>  <cmd>lua require'dap'.repl.open()<cr>
  nnoremap <silent> <leader>dt <cmd>lua require('dap-go').debug_test()<cr>
  nnoremap <silent> <leader>dtl <cmd>lua require('dap-go').debug_last_test()<cr>

endif



"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
