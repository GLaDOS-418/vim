" contents -
"   - PLUGIN MANAGER
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

" Visual {{{3
if has('nvim')
  " Plug 'dstein64/vim-startuptime'  " measure startup time
  " Plug 'Eandrju/cellular-automaton.nvim'  " fun
  " Plug 'goolord/alpha-nvim'     " A startup page
  Plug 'folke/noice.nvim' |       " floating command mode
     " \ Plug 'rcarriga/nvim-notify'
  Plug 'NvChad/nvim-colorizer.lua' " highlight colors in neovim

" colorschemes
  Plug 'rebelot/kanagawa.nvim'        " use kanagawa-dragon
  Plug 'EdenEast/nightfox.nvim'       " use terafox
  Plug 'rose-pine/neovim'

  " Plug 'luckasRanarison/nvim-devdocs'
  Plug 'stevearc/dressing.nvim'           " UI hooks in nvim for input

  " interface for github.com/tree-sitter/tree-sitter
  " TODO: add auto installation of treesitter servers
  Plug 'nvim-treesitter/nvim-treesitter',
       \{'do': ':TSUpdate'}               "   it's a parser generator
endif

Plug 'lifepillar/vim-gruvbox8'          " a better gruvbox
Plug 'ryanoasis/vim-devicons'           " icons for plugins
Plug 'machakann/vim-highlightedyank'    " flash highlight yanked region

" Source Control {{{3
Plug 'tpope/vim-fugitive'              " handle git commands
Plug 'airblade/vim-gitgutter'          " see git diff in buffer
Plug 'sindrets/diffview.nvim'

" Navigation {{{3
if has('nvim')
  Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'MunifTanjim/nui.nvim'

  Plug 'stevearc/oil.nvim' " edit filesystem like buffer

  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' } |
    \ Plug 'nvim-lua/plenary.nvim'


  " Telescope Extensions
  Plug 'nvim-telescope/telescope-project.nvim'
  Plug 'nvim-telescope/telescope-file-browser.nvim'
  Plug 'nvim-telescope/telescope-symbols.nvim'

  Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
  Plug 'folke/todo-comments.nvim'         " add and search todo comments in repo
  " Plug 'sourcegraph/sg.nvim', { 'do': 'nvim -l build/init.lua' }
else
  Plug 'preservim/nerdtree' |                 " open project drawer
  \ Plug 'Xuyuanp/nerdtree-git-plugin'        " mark files/dirs according to their status in drawer

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
endif

Plug 'vim-scripts/LargeFile'            " handling largefiles in vim
Plug 'tpope/vim-eunuch'                 " file modification commands
if has('nvim')
    " https://github.com/tpope/vim-eunuch/issues/56
    " SudoWrite doesn't work with eunuch due to a neovim limitation.
    Plug 'lambdalisue/vim-suda'
endif

" if has('nvim')
"   Plug 'folke/flash.nvim'
" else
  Plug 'easymotion/vim-easymotion'        " better movements
" endif
Plug 'christoomey/vim-tmux-navigator'   " navigate seamlessly between vim and tmux

" Architecture & Notes {{{3
Plug 'scrooloose/vim-slumlord'         " inline previews for plantuml activity dia
Plug 'aklt/plantuml-syntax'            " plantuml syntax highlight
Plug 'richardbizik/nvim-toc'           " create TOC for markdown files

" TODO: setup obsidian.vim
Plug 'epwalsh/obsidian.nvim'           " access obsidian from nvim

if has('nvim')
  " LSP Support {{{4
  Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}   " lsp config
  Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate', 'branch': 'v2.x' } " install LSP servers
  Plug 'williamboman/mason-lspconfig.nvim'               " bridge between lspconfig and mason
  Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'       " install third party tools
  Plug 'neovim/nvim-lspconfig'                           " lspconfig

  " Snippets {{{4
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}  " Required. completion engine
  Plug 'hrsh7th/nvim-cmp'         " Required
  Plug 'GLaDOS-418/friendly-snippets' " fork of: 'rafamadriz/friendly-snippets'

  " other snippets
  Plug 'honza/vim-snippets'
  Plug 'danymat/neogen'             " generate annotations for your code

  " find list of sources at:
  " https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
  Plug 'hrsh7th/cmp-nvim-lsp'                " Required
  Plug 'hrsh7th/cmp-buffer'                  " nvim-cmp source for buffer words
  Plug 'hrsh7th/cmp-nvim-lua'                " nvim-cmp source for neovim Lua API
  Plug 'hrsh7th/cmp-emoji'                   " nvim-cmp source for emojis
  Plug 'hrsh7th/cmp-path'                    " nvim-cmp source for filesystem paths
  Plug 'hrsh7th/cmp-calc'                    " evaluate mathematical expressions
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help' " displaying function signatures with the current parameter emphasized
  Plug 'petertriho/cmp-git'                  " git source for nvim-cmp
  Plug 'octaltree/cmp-look'                  " source for linux 'look' tool
  Plug 'saadparwaiz1/cmp_luasnip'

  " Code Formatting {{{4
  Plug 'stevearc/conform.nvim'
  Plug 'onsails/lspkind.nvim'    " icons for snippet completion source

  " Code Linting {{{4
  Plug 'mfussenegger/nvim-lint'

  " Visual {{{4
  Plug 'Bekaboo/dropbar.nvim'    " breadcrumbs
  " Plug 'SmiteshP/nvim-navic'   "  TODO: check dropbar vs nvim-navic + lsp-zero

  Plug 'kevinhwang91/nvim-ufo'      " set up code folding
  Plug 'kevinhwang91/promise-async' " required for nvim-ufo

  " Debugging {{{4
  Plug 'mfussenegger/nvim-dap'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'theHamsta/nvim-dap-virtual-text'
  " Plug 'jay-babu/mason-nvim-dap.nvim' "  TODO: auto install dap servers


  " language specific plugins {{{5

  " cpp
  Plug 'Civitasv/cmake-tools.nvim'
  Plug 'p00f/clangd_extensions.nvim'

  " golang
  Plug 'ray-x/go.nvim'
  Plug 'ray-x/guihua.lua' " required with go.nvim
  Plug 'leoluz/nvim-dap-go'

  " java
  Plug 'mfussenegger/nvim-jdtls'

  " html/css
  " Plug 'Jezda1337/nvim-html-css'  " TODO: external script completion setup
  Plug 'windwp/nvim-ts-autotag'

  " terminal
  Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

else
  " lspconfig {{{5
  Plug 'neoclide/coc.nvim', {'branch': 'release',
      \ 'do': { -> coc#util#install()}} " NodeJS based with LSP support

  " debugging {{{5
  " TODO : SET UP VIMSPECTOR FOR VIM
  " Plug 'puremourning/vimspector', {
  "    \  'do' : ':VimspectorUpdate'
  "    \ }

  Plug 'sheerun/vim-polyglot'            " collection of language packs for vim
  Plug 'aklt/plantuml-syntax'            " syntax/linting for plantuml

  Plug 'alvan/vim-closetag'              " to close markup lang tags
endif

" AI Tools {{{3
Plug 'github/copilot.vim' " Copilot setup
if has("nvim")
    Plug 'olimorris/codecompanion.nvim'    " AI completion
endif

" Code View {{{3
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'HampusHauffman/block.nvim'

" Editing Utils {{{3

" Plug 'ervandew/supertab'             " use tab for all insert mode completions
Plug 'tpope/vim-surround'              " surround text with tags
Plug 'godlygeek/tabular'               " text alignment

if has('nvim')
  Plug 'numToStr/Comment.nvim'
  Plug 'stevearc/aerial.nvim'            " alternative to majutsushi/tagbar
else
  Plug 'majutsushi/tagbar'               " show tags in sidebar using ctags
  Plug 'tpope/vim-commentary'            " comments lines, paragraphs etc.
endif
Plug 'tpope/vim-speeddating'           " incr/decr dates with <c-a> & <c-x>
Plug 'mbbill/undotree',                " gives a file changes tree
      \ {'on': 'UndotreeToggle'}

" Non-Editing Utils {{{3
if has('nvim')
  Plug 'stevearc/resession.nvim'
endif
Plug 'tpope/vim-abolish'    " working with word replacements
Plug 'tpope/vim-repeat'     " repeat vim commands, and not just the native ones
Plug 'airblade/vim-rooter'  " changes the cwd to project root


call plug#end()

"------------------------------------------------------------
" PLUGIN SETTINGS {{{1
"------------------------------------------------------------

" gitgutter - plugin config {{{2
  set updatetime=1000                 "wait how much time to detect file update
  let g:gitgutter_max_signs = 500     "threshold upto which gitgutter shows sign
  let g:gitgutter_highlight_lines = 0
  nnoremap gn :GitGutterNextHunk<CR>
  nnoremap gp :GitGutterPrevHunk<CR>
  nnoremap ga :GitGutterStageHunk<CR>
  nnoremap gu :GitGutterUndoHunk<CR>
  nnoremap <leader>hp :GitGutterPreviewHunk<CR>
  if !exists('&signcolumn')  " < vim 7.4.2201+
    let g:gitgutter_sign_column_always = 1
  endif

  let g:gitgutter_sign_added = '│'
  let g:gitgutter_sign_modified = '│'
  let g:gitgutter_sign_removed = '_'
  let g:gitgutter_sign_removed_first_line = '-'
  let g:gitgutter_sign_modified_removed = '~'
  highlight GitGutterAdd    guifg=#009900 guibg=#009900 ctermfg=2 ctermbg=2
  highlight GitGutterChange guifg=#bbbb00 guibg=#bbbb00 ctermfg=3 ctermbg=3
  highlight GitGutterDelete guifg=#ff2222 guibg=#ff2222 ctermfg=1 ctermbg=1

" vim-tmux-navigator {{{2
  let g:tmux_navigator_no_mappings = 1

  noremap <silent> <m-h> :<c-u>TmuxNavigateLeft<cr>
  noremap <silent> <m-j> :<c-u>TmuxNavigateDown<cr>
  noremap <silent> <m-k> :<c-u>TmuxNavigateUp<cr>
  noremap <silent> <m-l> :<c-u>TmuxNavigateRight<cr>
  noremap <silent> <m-\> :<c-u>TmuxNavigatePrevious<cr>

" vim-closetag - plugin config {{{2
  let g:closetag_filenames = '*.xml,*.xslt,*.htm,*.html,*.xhtml,*.phtml,*.tmpl'
  let g:closetag_xhtml_filenames = '*.xslt,*.xhtml,*.jsx'
  let g:closetag_filetypes = 'html,xml,xhtml,phtml,tmpl'
  let g:closetag_xhtml_filetypes = 'xslt,xhtml,jsx'
  let g:closetag_emptyTags_caseSensitive = 1
  let g:closetag_shortcut = '>'    " Shortcut for closing tags, default is '>'
  let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''


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


" tagbar - plugin config{{{2
if has('nvim')
  nnoremap <silent> <F8> :AerialToggle<cr>
else
  nnoremap <silent> <F8> :TagbarOpen fj<cr>
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


" neotree {{{2

  if has('nvim')
    noremap <leader>dd :Neotree toggle filesystem float dir=./<cr>
  endif

  " vim-rooter {{{2
  " 'CMakeLists.txt' , 'Makefile', 'build.sh', 'Earthfile'
  let g:rooter_patterns = [
        \ '.clangd',
        \ '*.sln', '*.csproj', 'build/env.sh', 'go.mod', 'Jenkinsfile',
        \'.git', '.hg', '.svn', '.root'
        \]

  let g:rooter_silent_chdir = 1
  let g:rooter_change_directory_for_non_project_files = 'current'
  let g:rooter_resolve_links = 1
  let g:rooter_cd_cmd = 'silent! lcd'



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
   let target_path = $HOME . '/.local/share/.vimundodir/'

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

nnoremap <leader>u :UndotreeToggle<cr>

" oil {{{2
nnoremap <leader>oo <cmd>Oil<cr>

"-----------------------------------------------------------
" LUA CONFIGS
"-----------------------------------------------------------

if has('nvim')

  lua require('treesitter_cfg')
  lua require('harpoon_cfg')
  lua require('lsp_cfg')
  lua require('nvim_dap')
  lua require('mason_cfg')
  lua require('resession_cfg')
  lua require('neotree_cfg')
  " lua require('ufo_cfg')
  lua require('misc')

  " telescope {{{2

  nnoremap <silent> <leader>ff <cmd>lua require('telescope_cfg').find_files_from_project_root()<cr>
  nnoremap <silent> <leader>fg <cmd>lua require('telescope_cfg').live_grep_from_project_root()<cr>

  nnoremap <silent> <leader>fp <cmd>lua require'telescope'.extensions.project.project{}<cr>
  nnoremap <silent> <leader>fb <cmd>Telescope buffers<cr><esc>
  nnoremap <silent> <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <silent> <leader>fc <cmd>Telescope git_commits<cr><esc>
  nnoremap <silent> <leader>fk <cmd>Telescope keymaps<cr>
  nnoremap <silent> <leader>fl <cmd>Telescope loclist<cr><esc>
  nnoremap <silent> <leader>fq <cmd>Telescope quickfix<cr><esc>


  " nvim-devdocs{{{2
  " nnoremap <leader>fd <cmd>DevdocsOpenFloat<cr>


  " todo-comments {{{2
  nnoremap <silent> <leader>td <cmd>TodoTelescope<cr>


  " sourcegraph/sg {{{2
  " nnoremap <leader>sg <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<cr>

  " neogen {{{2
  " generate annotation
  nnoremap <silent> <leader>n <cmd>Neogen<cr>

  " lsp-zero {{{2
  nnoremap <silent> <leader>lf <cmd>LspZeroFormat<cr>

  let g:snipMate = { 'snippet_version' : 1 }

  " nvim-dap {{{2
  " nnoremap <silent> <F5>  <cmd>lua require'dap'.continue()<cr>
  " nnoremap <silent> <F9>  <cmd>lua require'dap'.toggle_breakpoint()<cr>
  " nnoremap <silent> <F10> <cmd>lua require'dap'.step_over()<cr>
  " nnoremap <silent> <F11> <cmd>lua require'dap'.step_into()<cr>
  " nnoremap <silent> <F4>  <cmd>lua require'dap'.repl.open()<cr>
  " nnoremap <silent> <leader>dt <cmd>lua require('dap-go').debug_test()<cr>
  " nnoremap <silent> <leader>dtl <cmd>lua require('dap-go').debug_last_test()<cr>

endif

" akinsho/toggleterm.nvim {{{2
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

" copilot.vim {{{2
inoremap <silent><script><expr> <c-j> copilot#Accept("\<cr>")
let g:copilot_no_tab_map = v:true

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
