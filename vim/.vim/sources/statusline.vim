" contents -
"   - statusline
"   - autocommand handling

"------------------------------------------------------------
" STATUSLINE {{{1
"------------------------------------------------------------

set laststatus=2  " status line always enabled

" {{{2 - mode mapping
let g:currentmode={
      \'n'  :'normal',
      \'no' :'n·operator pending',
      \'v'  :'visual',
      \'V'  :'v·line',
      \'^V' :'v·block',
      \'s'  :'select',
      \'S'  :'s·line',
      \'^S' :'s·block',
      \'i'  :'insert',
      \'R'  :'replace',
      \'Rv' :'v·replace',
      \'c'  :'command',
      \'cv' :'vim ex',
      \'ce' :'ex',
      \'r'  :'prompt',
      \'rm' :'more',
      \'r?' :'confirm',
      \'!'  :'shell',
      \'t'  :'terminal' }

" Function: display errors from Ale in statusline
function! LinterStatus() abort " {{{2
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
function! PasteForStatusline() abort " {{{2
    let paste_status = &paste
    if paste_status == 1
        return "(p) "
    else
        return ""
    endif
endfunction

" Function: return git branch name from vim-fugitive plugin
function! GitBranchFugitive() abort " {{{2
  let branch=fugitive#head()
  if branch != ''
    return ' '.branch.' '
  else
    return ''
  endif
endfunction

" Function: change color of a user higlight group based on mode
function! ChangeModeColor() " {{{2
  " \v means 'very magic'
  if (mode() =~# '\v(n|no)')
    exe 'hi! User9 ctermfg=black ctermbg=yellow cterm=bold guifg=black guibg=yellow gui=bold'
  elseif (mode() =~# '\v(v|V)' || get(g:currentmode,strtrans(mode())) ==# 'v·block' )
    " visual block needed special handling because it is <c-v>
    exe 'hi! User9 ctermfg=white ctermbg=blue cterm=bold guifg=white guibg=blue gui=bold'
  elseif (mode() ==# 'i')
    exe 'hi! User9 ctermfg=white ctermbg=red cterm=bold guifg=white guibg=red gui=bold'
  elseif (mode() ==# 'c'|| mode() ==# 't')
    exe 'hi! User9 ctermfg=black ctermbg=cyan cterm=bold guifg=black guibg=cyan gui=bold'
  elseif (mode() ==# '\v(R|Rv)')
    exe 'hi! User9 ctermfg=black ctermbg=green cterm=bold guifg=black guibg=green gui=bold'
  else
    exe 'hi! User9 ctermfg=black ctermbg=white cterm=bold guifg=black guibg=white gui=bold'
  endif
  return ''
endfunction

" General Format: %-0{minwid}.{maxwid}{item}
" Higlight Groups: #<format-name>#  -> see :help hl for more group names
function! ActiveStatus() " {{{2
  let statusline=""                           " clear statusline
  let statusline.="%{ChangeModeColor()}"      " Changing the statusline color
  let statusline.="%#User9#"
  let statusline.="\ %3{toupper(get(g:currentmode,strtrans(mode())))} "
  let statusline.="%{PasteForStatusline()}"   " paste mode flag
  let statusline.="%<"                        " truncate to left
  let statusline.="%#PmenuSel#"               " let hl group to : popup menu normal line
  " let statusline.="%.15{GitBranch()}"       " github.com/vim/vim/issues/3197
  let statusline.="%.15{GitBranchFugitive()}" " git branch[max width=15]
  let statusline.="%#WildMenu#"               " hl group style: dir listing
  let statusline.="\ %f"                      " file name
  let statusline.="%r"                        " read only flag
  let statusline.="\ %m"                      " modifi(ed|able) flag
  let statusline.="%="                        " switching to the right side
  let statusline.="%#ErrorMsg#"               " hl group style: error message
  let statusline.="%{LinterStatus()}"         " error message from ALE plugin
  let statusline.="%#StatusLineNC#"
  let statusline.="%y"                        " file type
  let statusline.="[%{&fileencoding?&fileencoding:&encoding}"
  let statusline.=":%{&fileformat}\]"         " file format[unix/dos]
  "let statusline.="\ %3p%%"                  " file position percentage
  let statusline.="[r:%{v:register}]"
  let statusline.="%#Title#"
  let statusline.="\ %l:%-c\ "               " line[width-4ch, pad-left]:col[width-3ch, pad-right]
  let statusline.="%*"                        " switch to normal statusline hl
  let statusline.="\ %3L "                    " number of lines in buffer
  return statusline
endfunction

function! InactiveStatus() " {{{2
  " same as active status without colors
  let statusline="%<%#StatusLineNC#"
  let statusline.=" %3{toupper(get(g:currentmode,strtrans(mode())))} %{PasteForStatusline()}"
  let statusline.="%.15{GitBranchFugitive()}\ %f%r%=%{LinterStatus()}%y"
  let statusline.="[%{&fileencoding?&fileencoding:&encoding}][%{&fileformat}\]"
  let statusline.="\ %4l:%-3c\ %6L "
  return statusline
endfunction

setlocal statusline=%!ActiveStatus()

"------------------------------------------------------------
" AUTOCOMMAND HANDLING {{{1
"------------------------------------------------------------
augroup vim_statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatus()
augroup END

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
