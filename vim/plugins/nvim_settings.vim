" contents -
"   - LUA CONFIGS
"   - NAVIGATION
"   - ARCHITECTURE & NOTES
"   - LSP SUPPORT
"   - EDITING UTILS
"   - TERMINAL

"------------------------------------------------------------
" LUA CONFIGS {{{1
"------------------------------------------------------------

function! s:RequireLuaModule(module_name) abort " {{{2
  " pcall keeps startup alive while plugins are still being installed.
  execute 'lua pcall(require, ' . string(a:module_name) . ')'
endfunction

call s:RequireLuaModule('treesitter_cfg')
call s:RequireLuaModule('harpoon_cfg')
call s:RequireLuaModule('lsp_cfg')
call s:RequireLuaModule('nvim_dap')
call s:RequireLuaModule('mason_cfg')
call s:RequireLuaModule('resession_cfg')
call s:RequireLuaModule('neotree_cfg')
" call s:RequireLuaModule('ufo_cfg')
call s:RequireLuaModule('misc')
call s:RequireLuaModule('custom_code')

"------------------------------------------------------------
" NAVIGATION {{{1
"------------------------------------------------------------

" telescope {{{2
nnoremap <silent> <leader>fp <cmd>lua require'telescope'.extensions.project.project{}<cr>
nnoremap <silent> <leader>fb <cmd>Telescope buffers<cr><esc>
nnoremap <silent> <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <silent> <leader>fc <cmd>Telescope git_commits<cr><esc>
nnoremap <silent> <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <silent> <leader>fl <cmd>Telescope loclist<cr><esc>
nnoremap <silent> <leader>fq <cmd>Telescope quickfix<cr><esc>

" oil {{{2
nnoremap <leader>oo <cmd>Oil<cr>

"------------------------------------------------------------
" ARCHITECTURE & NOTES {{{1
"------------------------------------------------------------

" nvim-devdocs {{{2
" nnoremap <leader>fd <cmd>DevdocsOpenFloat<cr>
if exists('g:loaded_devdocs')
  nnoremap <leader>fd :DevdocsFind<CR>
endif

" todo-comments {{{2
nnoremap <silent> <leader>td <cmd>TodoTelescope<cr>

" sourcegraph/sg {{{2
" nnoremap <leader>sg <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<cr>

"------------------------------------------------------------
" LSP SUPPORT {{{1
"------------------------------------------------------------

" neogen {{{2
" generate annotation
" Keep the wrapper instead of calling :Neogen directly.
" Why: Neogen crashes on missing parsers because its generator calls
" `vim.treesitter.get_parser()` internally; the wrapper turns that into a
" clear message and a safe install hint instead.
" refs:
"   - ~/.vim/plugged/neogen/lua/neogen/generator.lua
"   - ~/.vim/plugged/nvim-treesitter/README.md
nnoremap <silent> <leader>n <cmd>lua require('neogen_cfg').run()<cr>

" lsp {{{2
" keep the formatting alias, but point it directly at conform now that
" native vim.lsp owns the attach/config flow instead of lsp-zero.
nnoremap <silent> <leader>lf <cmd>lua require('conform').format({ timeout_ms = 1000, async = false, lsp_fallback = true })<cr>

" snippets {{{2
let g:snipMate = { 'snippet_version' : 1 }

"------------------------------------------------------------
" EDITING UTILS {{{1
"------------------------------------------------------------

" indent-blankline {{{2
" legacy globals kept here for context beside the Neovim-only plugin.
let g:show_current_context = 1
let g:show_current_context_start = 1
let g:space_char_blankline = ' '
let g:show_current_context = 1
let g:show_current_context_start = 1

"------------------------------------------------------------
" TERMINAL {{{1
"------------------------------------------------------------

" akinsho/toggleterm.nvim {{{2
augroup toggleterm
  au!
  autocmd TermEnter term://*toggleterm#*
        \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
augroup END

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
