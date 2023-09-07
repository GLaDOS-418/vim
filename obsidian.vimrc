" insert normal mdoe
imap jk <Esc>

" invert ; <-> :
nmap ; :
nmap : ;

" j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" move to end/beginning of line(normal/visual  mode)
nmap E $
nmap B ^
vmap E $
vmap B ^

" Yank to system clipboard
set clipboard=unnamed

exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

" NOTE: must use 'map' and not 'nmap'
map [[ :surround_wiki
nunmap S
vunmap S
map S" :surround_double_quotes
map S' :surround_single_quotes
map S` :surround_backticks
map Sb :surround_brackets
map S( :surround_brackets
map S) :surround_brackets
map S[ :surround_square_brackets
map S[ :surround_square_brackets
map S{ :surround_curly_brackets
map S} :surround_curly_brackets

" Maps pasteinto to Alt-p
map <A-p> :pasteinto

" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands


" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands
exmap togglefold obcommand editor:toggle-fold
exmap togglefold obcommand editor:toggle-fold
nmap za :togglefold
nmap zo :togglefold
nmap zc :togglefold

exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

exmap foldall obcommand editor:fold-all
nmap zM :foldall

" Emulate Tab Switching https://vimhelp.org/tabpage.txt.html#gt
" requires Cycle Through Panes Plugins https://obsidian.md/plugins?id=cycle-through-panes
exmap tabnext obcommand cycle-through-panes:cycle-through-panes
nmap gt :tabnext
exmap tabprev obcommand cycle-through-panes:cycle-through-panes-reverse
nmap gT :tabprev


exmap nextHeading jsfile mdHelpers.js {jumpHeading(true)}
exmap prevHeading jsfile mdHelpers.js {jumpHeading(false)}
nmap ]] :nextHeading
nmap [[ :prevHeading

" Go Into Link
exmap goto_link obcommand editor:follow-link
nmap gd :goto_link
