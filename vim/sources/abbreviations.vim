" contents -
"   - PAIR HANDLING
"   - SPELLING
"   - EXTRA

"------------------------------------------------------------
" PAIR HANDLING {{{1
"------------------------------------------------------------

" square,angular brackets, braces, paranthesis
inoremap <leader>< <><++><esc>F>i
inoremap [      []<++><esc>F]i
inoremap (      ()<++><esc>F)i
inoremap {      {}<++><esc>F}i
inoremap {<cr>  {<cr>}<++><esc>O
inoremap (<cr>  (<cr>)<++><esc>O
inoremap (- (
inoremap [- [
inoremap {- {
inoremap [] []
inoremap () ()
inoremap {} {}

" quotes and backtick
" inoremap '- '
" inoremap "- "
" inoremap `- `
inoremap '' '
inoremap "" "
inoremap `` `
inoremap '      ''<++><esc>F'i
inoremap "      ""<++><esc>F"i
inoremap `      ``<++><esc>F`i
" inoremap '' ''
" inoremap "" ""
" inoremap `` ``
inoremap '''      '''  '''<esc>F<space>i
inoremap """      """  """<++><esc>F<space>i
inoremap ```      ```  ```<++><esc>F<space>i
inoremap '<cr>  '<cr>'<cr><++><esc>kO
inoremap "<cr>  "<cr>"<cr><++><esc>kO
inoremap `<cr>  `<cr>`<cr><++><esc>kO
inoremap '''<cr>  '''<cr>'''<cr><++><esc>kO
inoremap """<cr>  """<cr>"""<cr><++><esc>kO
inoremap ```<cr>  ```<esc>mza<cr><++><cr>```<cr><++><esc>`za

" misc
" inoremap /*- /*
inoremap /** /*
inoremap /*  /*  */<++><esc>F<space>i
inoremap /*<cr>  /*<cr>*/<cr><++><esc>kO<tab>

"------------------------------------------------------------
" MISC {{{1
"------------------------------------------------------------
" backslash key not working.
abbr &or; \|
abbr &bs; \


"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
