
"------------------------------------------------------------
" ABBREVIATIONS {{{
"------------------------------------------------------------
" pair handles {{{

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
inoremap '- '
inoremap "- "
inoremap `- `
inoremap '      ''<++><esc>F'i
inoremap "      ""<++><esc>F"i
inoremap `      ``<++><esc>F`i
inoremap '' ''
inoremap "" ""
inoremap `` ``
inoremap '''      '''  '''<esc>F<space>i
inoremap """      """  """<++><esc>F<space>i
inoremap ```      ```  ```<++><esc>F<space>i
inoremap '<cr>  '<cr>'<cr><++><esc>kO
inoremap "<cr>  "<cr>"<cr><++><esc>kO
inoremap `<cr>  `<cr>`<cr><++><esc>kO
inoremap '''<cr>  '''<cr>'''<cr><++><esc>kO
inoremap """<cr>  """<cr>"""<cr><++><esc>kO
inoremap ```<cr>  ```<cr>```<cr><++><esc>kO

" misc
inoremap /*- /*
inoremap /*  /*  */<++><esc>F<space>i
inoremap /*<cr>  /*<cr>*/<cr><++><esc>kO<tab>

" }}}}}}
" }}}

