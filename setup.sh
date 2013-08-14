#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# script to configure a Debian 7 desktop system.

cd $HOME

# resynchronize the package index files
#sudo apt-get update
sudo apt-get -q update

# install the newest versions of all packages currently installed on the system
sudo apt-get upgrade -y

# install git
sudo apt-get install -y git

# install curl
sudo apt-get install -y curl

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
# TODO setup Vim
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

### Node.js
# install nvm: node-version manager
# https://github.com/creationix/nvm
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# load nvm and install latest production node
source $HOME/.nvm/nvm.sh
# instead of "nvm install v0.10.15" and "nvm use v0.10.15" to install
# and use the latest 0.10.x version
nvm install v0.10
nvm use v0.10

# install jshint to allow checking of JavaScript code in vim
# http://jshint.com/
npm install -g jshint

# install rlwrap to provide libreadline features with node
# http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap
### /Node.js

### create /data/ directory, link to /d/
cd /
sudo mkdir -v data
sudo chown -v ubuntu:ubuntu data
sudo ln -v -s /data /d

### install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
