#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# script to configure a Debian 7 desktop system

cd $HOME

# TODO this should only run if the script is run directly
# resynchronize the package index files
#sudo apt-get update
#sudo apt-get -q update
# install the newest versions of all packages currently installed on the system
#sudo apt-get upgrade -y

# install git
sudo apt-get install -y git

# install curl
sudo apt-get install -y curl

# install tree
sudo apt-get install -y tree

### Fail2ban
# http://www.fail2ban.org/
sudo apt-get install -y fail2ban

### dotfiles
if [ -d dotfiles ]; then
    mv -iv dotfiles dotfiles.backup
fi

git clone https://github.com/paraschas/dotfiles.git

if [ -f .bashrc_custom ]; then
    mv -iv .bashrc_custom .bashrc_custom.backup
fi
if [ -f .gitconfig ]; then
    mv -iv .gitconfig .gitconfig.backup
fi

ln -s -f dotfiles/.bashrc .
ln -s -f dotfiles/.bash_profile .
cp -iv dotfiles/.bashrc_custom .
ln -s -f dotfiles/.gitignore .
cp -iv dotfiles/.gitconfig .
### /dotfiles

### Vim
sudo apt-get install -y vim
# backup
if [ -d .vim ]; then
    mv -iv .vim .vim.backup
fi
ln -s -f dotfiles/.vimrc .
# setup Vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
# install configured bundles
vim +BundleInstall +qall
### /Vim

### tmux
sudo apt-get install -y tmux
ln -s -f dotfiles/.tmux.conf .

### create /data/ directory, link to /d/
cd /
sudo mkdir -v data
sudo chown -v ubuntu:ubuntu data
sudo ln -v -s /data /d
