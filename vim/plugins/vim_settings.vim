" contents -
"   - NAVIGATION
"   - ARCHITECTURE & NOTES
"   - LSP SUPPORT

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

" fzf - plugin config {{{2
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

" https://rietta.com/blog/hide-gitignored-files-fzf-vim/
" fzf file fuzzy search that respects .gitignore
" If in git directory, show only files that are committed, staged, unstaged or untracked
" else use regular :Files
nnoremap <expr> <c-t> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-i': 'split',
      \ 'ctrl-v': 'vsplit' }
let g:fzf_tags_command = 'ctags -R'

" nerdtree {{{2
let NERDTreeQuitOnOpen = 1 " close nerdtree on opening a file
let NERDTreeMinimalUI  = 1
let NERDTreeShowHidden = 1

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

"------------------------------------------------------------
" ARCHITECTURE & NOTES {{{1
"------------------------------------------------------------

" vim-closetag - plugin config {{{2
let g:closetag_filenames = '*.xml,*.xslt,*.htm,*.html,*.xhtml,*.phtml,*.tmpl'
let g:closetag_xhtml_filenames = '*.xslt,*.xhtml,*.jsx'
let g:closetag_filetypes = 'html,xml,xhtml,phtml,tmpl'
let g:closetag_xhtml_filetypes = 'xslt,xhtml,jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'             " Shortcut for closing tags, default is '>'
let g:closetag_close_shortcut = '<leader>>' " Add > at current position without closing the current tag, default is ''

"------------------------------------------------------------
" LSP SUPPORT {{{1
"------------------------------------------------------------

" coc.nvim {{{2
"
" let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-cmake', 'coc-rust-analyzer']
"
" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: right now supertab uses tab so disabling the next two mappings
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
"
" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-@> coc#refresh()
"
" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
" " GoTo code navigation.
" nnoremap <silent> gd <Plug>(coc-definition)
" nnoremap <silent> gt <Plug>(coc-type-definition)
" nnoremap <silent> gi <Plug>(coc-implementation)
" nnoremap <silent> gr <Plug>(coc-references)
"
" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction
"
" " Symbol renaming.
" nmap <leader>rr <Plug>(coc-rename)
"
" " Formatting selected code.
" xmap <leader>cf  <Plug>(coc-format-selected)
" nmap <leader>cf  <Plug>(coc-format-selected)
"
" augroup coc
"   au!
"   " Highlight the symbol and its references when holding the cursor.
"   autocmd CursorHold * silent call CocActionAsync('highlight')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup END

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
