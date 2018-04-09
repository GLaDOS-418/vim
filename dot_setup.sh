
#installed packages

#creating links to configs
ln -s dotfiles/vim/.vimrc ~/.vimrc
ln -s dotfiles/bash/.bashrc ~/.bashrc
ln -s dotfiles/bash/.bash_profile ~/.bash_profile
ln -s ~/.vimrc ~/.config/nvim/init.vim

#installed packaged
sudo pacman -Ss neovim
sudo pacman -Sy texlive-most texlive-lang
sudo yaourt -Sy biber
sudo pacman -Sy mupdf
