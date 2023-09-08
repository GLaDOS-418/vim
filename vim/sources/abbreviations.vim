" contents -
"   - HANDLE JUMP MARKERS
"   - PAIR HANDLING
"   - SPELLING
"   - EXTRA

"------------------------------------------------------------
" HANDLE JUMP MARKERS {{{1
"------------------------------------------------------------
" inoremap <space><tab> <esc>/<++><CR>:nohl<CR>"_c4l
" inoremap <leader><space><tab> <++><esc>4h?<++><CR>:nohl<CR>"_c4l
" nnoremap <space><tab><tab> :%s/<++>//g<CR>
" inoremap <leader><tab> <esc>/<--><CR>:nohl<CR>"_c4l
" nnoremap <s-tab><s-tab> :%s/<++>//g<CR>
inoremap j<tab> <esc>/<++><CR>:nohl<CR>"_c4l
inoremap k<tab> <++><esc>4h?<++><CR>:nohl<CR>"_c4l
inoremap <leader>m <++><esc>

"------------------------------------------------------------
" PAIR HANDLING {{{1
"------------------------------------------------------------

" square,angular brackets, braces, paranthesis
inoremap <>    <><++><esc>F>i
inoremap ()    ()<++><esc>F)i
inoremap []    []<++><esc>F]i
inoremap {}    {}<++><esc>F}i
inoremap {<cr> {<cr>}<++><esc>O
" inoremap (      ()<++><esc>F)i
" inoremap (<cr>  (<cr>)<++><esc>O
" inoremap {      {}<++><esc>F}i
" inoremap [      []<++><esc>F]i

" quotes and backtick
inoremap ''      ''<++><esc>F'i
inoremap ""      ""<++><esc>F"i
inoremap ``      ``<++><esc>F`i
inoremap '''      ''''''<++><esc>6hi
inoremap """      """"""<++><esc>6hi
inoremap ```      ``````<++><esc>6hi
inoremap '<cr>  '<cr>'<cr><++><esc>kO
inoremap "<cr>  "<cr>"<cr><++><esc>kO
inoremap `<cr>  `<cr>`<cr><++><esc>kO
inoremap '''<cr>  '''<cr>'''<cr><++><esc>kO
inoremap """<cr>  """<cr>"""<cr><++><esc>kO

" gnerally used for code block, so slightly diff behaviour than quotes to
" enable specifying programming-language of the block.
inoremap ```<cr>  ```<esc>mza<cr><++><cr>```<cr><++><esc>`za

" misc
inoremap /** /*
inoremap /*  /*  */<++><esc>F<space>i
inoremap /*<cr>  /*<cr>*/<cr><++><esc>kO<tab>

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
