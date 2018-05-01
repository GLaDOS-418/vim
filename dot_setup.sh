# crontab entries
# * * * * * 'sudo arpon -d -i wlp3s0 -D'

#fstab entry for windows mount
# UUID=CC8AA6D38AA6B97A /mnt/windows/  ntfs    defaults,noatime 0 2

#installed packages
#creating links to configs
ln -s dotfiles/vim/.vimrc ~/.vimrc
ln -s dotfiles/bash/.bashrc ~/.bashrc
ln -s dotfiles/bash/.bash_profile ~/.bash_profile
ln -s ~/.vimrc ~/.config/nvim/init.vim

#installed packaged
sudo pacman -Ss neovim
sudo pacman -Sy texlive-most texlive-lang
yaourt -Sy biber
sudo pacman -Sy mupdf
sudo yaourt tree
sudo pacman -Sy bash-completion
sudo pacman -Sy python-pipenv
sudo pacman -Sy python-tensorflow tensorboard
sudo pacman -Sy docker docker-compose docker-machine
sudo pacman -Sy docker docker-compose docker-machine
yaourt -Sy kubectl-bin
yaourt -Sy minikube-bin
yaourt -sS docker-machine-driver-kvm2
sudo pacman -Sy putty
sudo pacman -Sy libvirt qemu-headless ebtables dnsmasq
