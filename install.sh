#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

# Install curl, tar, git, other dependencies if missing
PACKAGES_NEEDED="\
    ripgrep \
    bat \
    fzf \
    apt-utils"

if ! dpkg -s ${PACKAGES_NEEDED} > /dev/null 2>&1; then
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        sudo apt-get update
    fi
    sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
    sudo apt-get -y -q install ${PACKAGES_NEEDED}
fi

# sudo apt-get --assume-yes install silversearcher-ag bat fuse

# install latest neovim
wgetr https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz
tar -xvf nxim-linux64.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/local/bin/nvim

rm -rf $HOME/.config
mkdir $HOME/.config
ln -s "$(pwd)/config/nvim" "$HOME/.config/nvim"

nvim +'PlugInstall --sync' +qa

sudo chsh -s "$(which zsh)" "$(whoami)"
