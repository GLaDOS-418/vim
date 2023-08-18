" contents -
"     - WSL


" -------------------------------------------------------------
"  WSL {{{1
" -------------------------------------------------------------
let s:clip_yank = '/mnt/c/Windows/System32/clip.exe'
if !has('clipboard') && executable(s:clip_yank)
  func! GetSelectedText()
  " https://stackoverflow.com/a/50281147/4646394
    normal gv"xy
    let text = substitute(getreg("x"), "\n", "\r\n", 'g') " convert lf to crlf
    return text
  endfunc

  " augroup WSLYank
  "   autocmd!
  "   " autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents)).' | '.s:clip_yank)
  "   autocmd TextYankPost * call system('clip.exe', GetSelectedText())
  " augroup END

  noremap <C-c> :call system('clip.exe', GetSelectedText())<CR>
endif

if !has('clipboard') && executable('powershell.exe')
  func! GetClipboardText()
    let text = substitute(system( 'powershell.exe -Command Get-Clipboard'), "\r", '', 'g') " convert crlf to lf
    return text[:-2] " remove last newline from windows clipboard
  endfunc

  nnoremap <M-v> :exe 'norm! a'. GetClipboardText()<CR>
  nnoremap <C-M-v> :exe 'norm! a'. GetClipboardText()<CR>
endif

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
