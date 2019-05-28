"------------------------------------------------------------
" GUI OPTIONS {{{1
"------------------------------------------------------------

if has('gui_running')
  set guioptions-=T  " no toolbar
  set guioptions-=m  " no menubar
  set guioptions-=r  " no scrollbar
  set guioptions-=R  " no scrollbar
  set guioptions-=l  " no scrollbar
  set guioptions-=L  " no scrollbar

  " 0oO iIlL17 g9qGQcCuUsSEFBD ~-+ ,;:!|?%/== <<{{(([[]]))}}>> "'`
  if has("gui_gtk2") || has("gui_gtk3")
      set anti enc=utf-8
      set guifont=Source\ Code\ Pro\ Medium\ 12
  elseif has("gui_win32") || has("gui_win64" )
      set lines=30
      set columns=110
      set guifont=Source_Code_Pro_Medium:h11:cANSI:qDRAFT
  endif
endif

" clearing the t_vb variable deactivates flashing
" declared again because the variable resets on gui start
set t_vb=
