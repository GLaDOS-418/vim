# (n)vim config

### CONTENTS

* vimrc
* gvimrc
* init.lua
* obsidian.vimrc
* vim-plug glob
* source code pro font (tff) - for gvimrc

### SOURCE

* [A Good Vimrc]( https://web.archive.org/web/20180603131820/https://dougblack.io/words/a-good-vimrc.html )
* [Minimal Vim Configuration With vim-plug: For A Barebones Starter Config - devel.tech]( https://devel.tech/snippets/n/vIMmz8vZ/minimal-vim-configuration-with-vim-plug/#putting-it-all-together )
* [GitHub - junegunn/vim-plug: Minimalist Vim Plugin Manager]( https://github.com/junegunn/vim-plug )
* [How I boosted my Vim &raquo; nvie.com]( https://nvie.com/posts/how-i-boosted-my-vim/ )
* [Vim 101: Set Hidden – usevim – Medium]( https://medium.com/usevim/vim-101-set-hidden-f78800142855 )
* [Vim for Writers - NaperWriMo Wiki]( https://naperwrimo.org/wiki/index.php?title=Vim_for_Writers )
* ["Vim Side Search: Making Search Fun Again"]( https://ddrscott.github.io/blog/2016/side-search/ )
* [The Last Statusline For Vim – Hacker Noon]( https://hackernoon.com/the-last-statusline-for-vim-a613048959b2 )
* [Why I love Vim: It’s the lesser-known features that make it so amazing]( https://medium.freecodecamp.org/learn-linux-vim-basic-features-19134461ab85 )

### USEFUL LINKS

* [Learn Vimscript the Hard Way]( http://learnvimscriptthehardway.stevelosh.com/ )
* [a guide to LSP in vim]( https://old.reddit.com/r/vim/comments/b33lc1/a_guide_to_lsp_auto_completion_in_vim/#eix8cuk )
* [How I Vim]( http://howivim.com/ ) - interviews
* [Vimcasts - Free screencasts about the text editor Vim]( http://vimcasts.org/ )
* [usevim – Medium]( https://medium.com/usevim )
* [How I Take Notes With Vim, Markdown, and Pandoc   - things james does]( https://jamesbvaughan.com/markdown-pandoc-notes/ )
* [Building vim from source]( https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source )
* [ripgrep is faster than {grep, ag, git grep, ucg, pt, sift} - Andrew Gallant&#39;s Blog]( https://blog.burntsushi.net/ripgrep/ )
* [GitHub - bchretien/vim-profiler: Utility script to profile (n)vim (e.g. startup times of plugins)]( https://github.com/bchretien/vim-profiler )
* [TabNine | Deep Learning for code completion]( https://www.tabnine.com/ ) - freemium
* [Improving Vim Workflow With fzf | Pragmatic Pineapple]( https://pragmaticpineapple.com/improving-vim-workflow-with-fzf/ )
* [How to copy text from vim to system clipboard? · Issue #892 · microsoft/WSL · GitHub]( https://github.com/Microsoft/WSL/issues/892 )
* [Tmux and Vim — configurations to be better together | BugSnag Blog]( https://www.bugsnag.com/blog/tmux-and-vim/ )

### DISCUSSIONS

* [LSP | Langserver.org]( https://langserver.org/ )
* [Do LSP's make tag generating tools obsolete?]( https://www.reddit.com/r/vim/comments/fj9tsz/do_lsps_make_tag_generating_tools_obsolete/ )
* [Why do Vim experts prefer buffers over tabs? - Stack Overflow]( https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26745051 )
* [A LSP client maintainer's view of the protocol | YCM]( https://www.reddit.com/r/vim/comments/b3yzq4/a_lsp_client_maintainers_view_of_the_lsp_protocol/ )

### IMPROVE VIM

* [GitHub - MordechaiHadad/bob: A version manager for neovim]( https://github.com/MordechaiHadad/bob )
* [GitHub - akrawchyk/awesome-vim: The Vim plugin shortlist]( https://github.com/akrawchyk/awesome-vim )
* [Vim Awesome]( https://vimawesome.com/ )
* [Dotfyle | Neovim Plugin Search | Neovim Config Search | Neovim News]( https://dotfyle.com/ )
* [rockerBOO/awesome-neovim: Collections of awesome neovim plugins.](https://github.com/rockerBOO/awesome-neovim#cursorline)
* [nvimawesome](https://nvim-awesome.vercel.app/)
* [Modules labeled 'neovim' - LuaRocks]( https://luarocks.org/labels/neovim )
* [neovimcraft]( https://neovimcraft.com/ )
* [Vim Tips Wiki | Fandom]( https://vim.fandom.com/wiki/Vim_Tips_Wiki )

### SOCIAL MEDIA

* [@bitsmirk/vim\* / X](https://twitter.com/i/lists/1699729447396712479)
* [r/vim]( https://reddit.com/r/vim )
* [r/neovim]( https://www.reddit.com/r/neovim/ )

### WIP
* [GitHub - jmbuhr/otter.nvim: Just ask an otter! 🦦]( https://github.com/jmbuhr/otter.nvim )

### KNOWN ISSUES
* when using airblade/vim-rooter: Changes Vim working directory to project root.( https://github.com/airblade/vim-rooter ) - doesn't work well with nerdtree because it unsets `autochdir` and because of that, I can't open NerdTree in the VCS root on vim start.

### TODO
right now there's an attempt to keep the config compatible with both vim and neovim.
Although, I might move completely to neovim and put vim config in archive mode or
maybe i'll restructure my config to separate vim/neovim/vscode-nvim config.

As of Aug 2023, after Bram Moolenaar's passing, [vim's future](https://github.com/vim/vim/discussions/12736) is yet to be seen.
vim was already an improvement over vi and neovim is an attempt to improve upon that.

neovim has tree-sitter support, native lua support, more exclusive plugins, client-server architecture, community driven,
better out-of-the-box config, several other optimisations (e.g. [better file change detection](https://github.com/neovim/neovim/issues/1380)
(you can use [this workaround](https://github.com/GLaDOS-418/vim/blob/ea23b01022f56358030163471ed2f484ad9d4407/vimrc#L430) ) ),
it has an inbuilt library 'Checkhealth' to see if everything's installed properly or not.

You can embed nvim into other editors (e.g. [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim), [firenvim](https://github.com/glacambre/firenvim) ),
no more half-baked vim emulations and more work is being done on this and more. the nvim code is being refactored to move away
from vimscript one part at a time to lua and it's a fast moving project.

nvim was moving ahead of vim development in terms of new features. it has more robust async support (RPC API),
native lsp support and a better dap support, embedded terminal support, floating windows etc.
a few of which eventually found its ways to vim but, apparently nvim does them better.

