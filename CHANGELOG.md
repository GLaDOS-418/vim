## CHANGELOG

#### 19-05-2019
* After several wasted hours, a working implementation to copy and paste between windows and vim clipboard, albeit unoptimized, is available.
* Might need to revisit augroup part of clipboard copy. Everytime when something was getting copied to clilp.exe it messes with cursor of vim, it starts deleting somewhere else, cursor jumping all over the page etc. (commented for now)
* Could have used `kana/vim-fakeclip` but, the last commit is 2yrs ago.
* XServer solutions are also an option.
