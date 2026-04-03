" contents -
"   - PLUGIN MANAGER
"   - PLUGIN LOADER

"------------------------------------------------------------
" PLUGIN MANAGER {{{1
"------------------------------------------------------------

" do not parse this file for any *.log, *.txt files & files larger than 1MB.
" this keeps plugin startup work away from throwaway or heavy buffers.
let g:skip_plugins = 0
let s:ext = expand('%:e')

if s:ext ==# 'log' || s:ext ==# 'txt'
  let g:skip_plugins = 1
else
  " get file size in bytes
  let s:filesize = getfsize(expand('%:p'))
  " if file is larger than 1MB (1_048_576 bytes), skip plugins
  if s:filesize > 1048576
    let g:skip_plugins = 1
  endif
endif

if exists('g:skip_plugins') && g:skip_plugins
  finish
endif

" download vim-plug and install plugins if vim started without plug.
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" helper function to check for conditions and load plugins. Follow below pattern:
" Cond( condition1, Cond(condition2,Cond(condition3, {dictionary}) ) )
" kept here because plugin declarations still live in sourced Vimscript files.
function! Cond(cond, ...) "{{{2
  let opts = get(a:000, 0, {})
  return (a:cond) ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

function! HasPython()
  return has('python') || has('python3')
endfunction

function! s:SourcePluginFile(file_name) abort " {{{2
  execute 'source ' . fnameescape(SourceFileName(g:sep, g:vim_home, 'plugins', a:file_name))
endfunction

"------------------------------------------------------------
" PLUGIN LOADER {{{1
"------------------------------------------------------------

" plug plugin setup. vim_home and sep in vimrc
call plug#begin(vim_home . sep . 'plugged')

" keep plugin declarations split by editor so vimrc can stay shared.
call s:SourcePluginFile('common.vim')

if has('nvim')
  call s:SourcePluginFile('nvim.vim')
else
  call s:SourcePluginFile('vim.vim')
endif

" automatically install plugins after declarations have been registered.
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

call plug#end()

" plugin settings load after plug#end so commands and plug mappings exist.
call s:SourcePluginFile('common_settings.vim')

if has('nvim')
  call s:SourcePluginFile('nvim_settings.vim')
else
  call s:SourcePluginFile('vim_settings.vim')
endif

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
