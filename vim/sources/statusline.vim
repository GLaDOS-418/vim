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
  let branch=''
  if exists('g:loaded_fugitive')
    " let branch .= fugitive#Head()
    let branch .= FugitiveStatusline()  " better. falls back on commits etc. if not on any branch
  elseif executable('git')
    let branch .= system('git branch --show-current 2> /dev/null | tr -d "\n" ')
  endif

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
    exe 'hi! StatuslineColorGroup ctermfg=235 ctermbg=214 cterm=bold guifg=#282828 guibg=#fabd2f gui=bold' 
  elseif (mode() =~# '\v(v|V)' || get(g:currentmode,strtrans(mode())) ==# 'v·block' )
    " visual block needed special handling because it is <c-v>
    exe 'hi! StatuslineColorGroup ctermfg=223 ctermbg=66 cterm=bold guifg=#ebdbb2 guibg=#458588 gui=bold'
  elseif (mode() ==# 'i')
    exe 'hi! StatuslineColorGroup ctermfg=223 ctermbg=124 cterm=bold guifg=#ebdbb2 guibg=#cc241d gui=bold'
  elseif (mode() ==# 'c'|| mode() ==# 't')
    exe 'hi! StatuslineColorGroup ctermfg=235 ctermbg=109 cterm=bold guifg=#282828 guibg=#83a598 gui=bold'
  elseif (mode() ==# '\v(R|Rv)')
    exe 'hi! StatuslineColorGroup ctermfg=235 ctermbg=142 cterm=bold guifg=#282828 guibg=#b8bb26 gui=bold'
  else
    exe 'hi! StatuslineColorGroup ctermfg=235 ctermbg=223 cterm=bold guifg=#282828 guibg=#ebdbb2 gui=bold'
  endif
  return ''
endfunction

exe 'hi! SGit ctermfg=223 ctermbg=235 cterm=bold guifg=#ebdbb2 guibg=#282828 gui=bold'

" Define the custom highlight group for the filename
hi FixedFilename ctermfg=White ctermbg=Black guifg=#FFFFFF guibg=#000000

" General Format: %-0{minwid}.{maxwid}{item}
" Higlight Groups: #<format-name>#  -> see :help hl for more group names
function! ActiveStatus() " {{{2
  let statusline=""                           " clear statusline
  let statusline.="%{ChangeModeColor()}"      " Changing the statusline color
  let statusline.="%#StatuslineColorGroup#"
  let statusline.="\ %3{toupper(get(g:currentmode,strtrans(mode())))} "
  let statusline.="%{PasteForStatusline()}"   " paste mode flag
  let statusline.="%<"                        " truncate to left
  let statusline.="%#PmenuSel#"               " let hl group to : popup menu normal line

  " let statusline.="%.17{GitBranch()}"              " github.com/vim/vim/issues/3197
  let statusline.="%#SGit#%.17{GitBranchFugitive()}" " git branch[max width=17]

  let statusline.="%#WildMenu#"               " hl group style: dir listing
  let statusline.="%#FixedFilename#\ %f"      " file name
  let statusline.="%r"                        " read only flag
  let statusline.="\ %m"                      " modifi(ed|able) flag
  let statusline.="%="                        " switching to the right side
  let statusline.="%#ErrorMsg#"               " hl group style: error message
  let statusline.="%#StatusLineNC#"
  let statusline.="%y"                        " file type
  let statusline.="[%{&fileencoding?&fileencoding:&encoding}"
  let statusline.=":%{&fileformat}\]"         " file format[unix/dos]
  "let statusline.="\ %3p%%"                  " file position percentage
  let statusline.="[r:%{v:register}]"
  let statusline.="%#Title#"
  let statusline.="\ %l:%-c\ "                " line[width-4ch, pad-left]:col[width-3ch, pad-right]
  let statusline.="%*"                        " switch to normal statusline hl
  let statusline.="\ %3L "                    " number of lines in buffer
  return statusline
endfunction

function! InactiveStatus() " {{{2
  " same as active status without colors
  let statusline="%<%#StatusLineNC#"
  let statusline.=" %3{toupper(get(g:currentmode,strtrans(mode())))} %{PasteForStatusline()}"
  let statusline.="%.15{GitBranchFugitive()}\ %f%r%=%y"
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
  autocmd CursorMoved,BufWinEnter,FocusGained,WinEnter,BufEnter * setlocal statusline=%!ActiveStatus()
  autocmd BufWinLeave,FocusLost,WinLeave,BufLeave * setlocal statusline=%!InactiveStatus()
augroup END

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
