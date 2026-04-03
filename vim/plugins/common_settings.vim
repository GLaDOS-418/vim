" contents -
"   - SHARED WRAPPERS
"   - SOURCE CONTROL
"   - NAVIGATION
"   - EDITING UTILS
"   - NON-EDITING UTILS

"------------------------------------------------------------
" SHARED WRAPPERS {{{1
"------------------------------------------------------------

" stable front-door mappings keep the same intent even when the backend differs.
function! s:ProjectFiles() abort " {{{2
  if has('nvim')
    lua require('telescope_cfg').find_files_from_project_root()
    return
  endif

  silent call system('git rev-parse --is-inside-work-tree')
  if v:shell_error == 0
    execute 'GFiles --exclude-standard --others --cached'
  else
    execute 'Files'
  endif
endfunction

function! s:ProjectGrep() abort " {{{2
  if has('nvim')
    lua require('telescope_cfg').live_grep_from_project_root()
  else
    call feedkeys(":Rg ", 'nt')
  endif
endfunction

function! s:ProjectTree() abort " {{{2
  if has('nvim')
    execute 'Neotree toggle filesystem float dir=./'
  else
    execute 'NERDTreeToggleVCS'
  endif
endfunction

function! s:ProjectOutline() abort " {{{2
  if has('nvim')
    execute 'AerialToggle'
  else
    execute 'TagbarOpen fj'
  endif
endfunction

nnoremap <silent> <leader>ff :<C-u>call <SID>ProjectFiles()<CR>
nnoremap <silent> <leader>fg :<C-u>call <SID>ProjectGrep()<CR>
nnoremap <silent> <leader>dd :<C-u>call <SID>ProjectTree()<CR>
nnoremap <silent> <F8> :<C-u>call <SID>ProjectOutline()<CR>

if !has('nvim')
  nnoremap <silent> <leader>d :<C-u>call <SID>ProjectTree()<CR>
endif

"------------------------------------------------------------
" SOURCE CONTROL {{{1
"------------------------------------------------------------

" gitgutter - plugin config {{{2
set updatetime=1000              " wait how much time to detect file update
let g:gitgutter_max_signs = 500  " threshold upto which gitgutter shows sign
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

" fugitive {{{2

" Finds the first git commit that introduced the lines in the current visual selection
function! s:GitIntroCommitRange(first, last) abort
  execute 'Git log --reverse -n 1 --oneline -L '
        \ . a:first . ',' . a:last . ':%'
endfunction

" Normal: current line
nnoremap <silent> <leader>gi :<C-u>call <SID>GitIntroCommitRange(line('.'), line('.'))<CR>

" Visual: selected line range (linewise/charwise/blockwise all OK; we use line numbers)
xnoremap <silent> <leader>gi :<C-u>call <SID>GitIntroCommitRange(line("'<"), line("'>"))<CR>

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

" vim-tmux-navigator {{{2

" Already using <c-h> <c-j> <c-k> <c-l> for panes' navigation
let g:tmux_navigator_no_mappings = 1

" Disable tmux navigator when zooming the Vim pane
" let g:tmux_navigator_disable_when_zoomed = 1

" If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
" NOTE: I prefer preserving zoom than disabling tmux navigator
let g:tmux_navigator_preserve_zoom = 1

" for some reason this plugin doesn't work with vim out of the box (only the keymappings, explicit commands work)
" https://github.com/christoomey/vim-tmux-navigator/issues/294#issuecomment-841582996
" use the other external script in tmux.conf as pointed out in the above comment
noremap <silent> <m-h> <cmd>TmuxNavigateLeft<cr>
noremap <silent> <m-j> <cmd>TmuxNavigateDown<cr>
noremap <silent> <m-k> <cmd>TmuxNavigateUp<cr>
noremap <silent> <m-l> <cmd>TmuxNavigateRight<cr>
noremap <silent> <m-\> <cmd>TmuxNavigatePrevious<cr>

" vim-easymotion {{{2
let g:EasyMotion_do_mapping  = 0 " Disable default mappings
let g:EasyMotion_smartcase   = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" search word
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

"------------------------------------------------------------
" EDITING UTILS {{{1
"------------------------------------------------------------

" undotree {{{2
if has('persistent_undo')
  let target_path = $HOME . '/.local/share/.vimundodir/'

  " create the directory and any parent directories
  " if the location does not exist.
  if !isdirectory(target_path)
    call mkdir(target_path, 'p', 0700)
  endif

  let &undodir = target_path
  set undofile
endif

nnoremap <leader>u :UndotreeToggle<cr>

"------------------------------------------------------------
" NON-EDITING UTILS {{{1
"------------------------------------------------------------

" vim-rooter {{{2
" 'CMakeLists.txt' , 'Makefile', 'build.sh', 'Earthfile'
let g:rooter_patterns = [
      \ '.clangd'
      \,'*.sln', '*.csproj', 'build/env.sh', 'go.mod', 'Jenkinsfile'
      \,'.git', '.hg', '.svn', '.root'
      \,'package.json', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml',
      \]

let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_resolve_links = 1
let g:rooter_cd_cmd = 'silent! lcd'

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
