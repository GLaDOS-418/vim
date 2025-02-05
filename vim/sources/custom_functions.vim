" contents -
"   - CUSTOM FUNCTIONS

"------------------------------------------------------------
" CUSTOM FUNCTIONS {{{1
"------------------------------------------------------------
" cycle between colorschemes
let g:current_colorscheme = 0

function! CycleColorscheme()
  let g:current_colorscheme = (g:current_colorscheme + 1) % len(g:colorschemes)
  execute 'colorscheme ' . g:colorschemes[g:current_colorscheme]
  echo "colorscheme: " . g:colorschemes[g:current_colorscheme]
endfunction

function! BuildUml() " {{{2
  if $PLANTUML != ''
    execute "w"
    execute "!java -jar $PLANTUML -tsvg %"
  else
    echo 'PLANTUML env variable not set!!'
  endif
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction


function! VisualSelection(direction, extra_filter) range " {{{2
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


function! Git_Repo_Cdup() " Get the relative path to repo root {{{2
    "Ask git for the root of the git repo (as a relative '../../' path)
    let git_top = system('git rev-parse --show-cdup')
    let git_fail = 'fatal: Not a git repository'
    if strpart(git_top, 0, strlen(git_fail)) == git_fail
        " Above line says we are not in git repo. Ugly. Better version?
        return ''
    else
        " Return the cdup path to the root. If already in root,
        " path will be empty, so add './'
        return './' . git_top
    endif
endfunction

function! CD_Git_Root() " {{{2
    execute 'cd '.Git_Repo_Cdup()
    let curdir = getcwd()
    echo 'CWD now set to: '.curdir
endfunction


" Define the wildignore from gitignore
function! WildignoreFromGitignore() " {{{2
    silent call CD_Git_Root()
    let gitignore = '.gitignore'
    if filereadable(gitignore)
        let igstring = ''
        for oline in readfile(gitignore)
            let line = substitute(oline, '\s|\n|\r', '', "g")
            if line =~ '^#' | con | endif
            if line == '' | con  | endif
            if line =~ '^!' | con  | endif
            if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
            let igstring .= "," . line
        endfor
        let execstring = "set wildignore+=".substitute(igstring,'^,','',"g")
        execute execstring
        silent !echom 'Wildignore defined from gitignore in: '.getcwd()
    else
        silent !echom 'Unable to find gitignore'
    endif
endfunction

function! ShowColorSchemeName() " {{{2
    try
        echo g:colors_name
    catch /^Vim:E121/
        echo "default
    endtry
endfunction

function! SetColors() " {{{2
 let statusline=""
 let statusline.="%1* 46"
 let statusline.="%2* 45"
 let statusline.="%3* 44"
 let statusline.="%4* 43"
 let statusline.="%5* 42"
 let statusline.="%6* 41"
 let statusline.="%7* 40"
 let statusline.="%8* 39"
 let statusline.="%9* 38"
 let statusline.="%0* 37"
 let statusline.="%#SpecialKey# 36"
 let statusline.="%#EndOfBuffer# 35"
 let statusline.="%#NonText# 34"
 let statusline.="%#Directory# 33"
 let statusline.="%#ErrorMsg# 32"
 let statusline.="%#IncSearch# 31"
 let statusline.="%#Search# 30"
 let statusline.="%#MoreMsg# 29"
 let statusline.="%#ModeMsg# 28"
 let statusline.="%#LineNr# 27"
 let statusline.="%#CursorLineNr# 26"
 let statusline.="%#Question# 25"
 let statusline.="%#StatusLine# 24"
 let statusline.="%#StatusLineNC# 23"
 let statusline.="%#Title# 22"
 let statusline.="%#VertSplit# 21"
 let statusline.="%#Visual# 20"
 let statusline.="%#VisualNOS# 19"
 let statusline.="%#WarningMsg# 18"
 let statusline.="%#WildMenu# 17"
 let statusline.="%#Folded# 16"
 let statusline.="%#FoldColumn# 15"
 let statusline.="%#DiffAdd# 14"
 let statusline.="%#DiffChange# 13"
 let statusline.="%#DiffDelete# 12"
 let statusline.="%#DiffText# 11"
 let statusline.="%#SignColumn# 10"
 let statusline.="%#SpellBad# 9"
 let statusline.="%#SpellCap# 8"
 let statusline.="%#SpellRare# 7"
 let statusline.="%#SpellLocal# 6"
 let statusline.="%#Conceal# 05"
 let statusline.="%#Pmenu# 04"
 let statusline.="%#PmenuSel# 03"
 let statusline.="%#PmenuSbar# 02"
 let statusline.="%#PmenuThumb# 01"
 return statusline
endfunction

function! TestColors() " {{{2
  setlocal statusline=%!SetColors()
endfunction

function! MouseToggle() " {{{2
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
endfunction

"------------------------------------------------------------
" END {{{1
"------------------------------------------------------------
