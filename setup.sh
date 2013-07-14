#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# script to configure a Debian desktop system.

### make a backup if needed
cd $HOME
if [ -d dotfiles ]; then
    mv -iv dotfiles dotfiles.backup
fi
if [ -d .vim ]; then
    mv -iv .vim .vim.backup
fi

### TODO setup Vim
sudo apt-get install -y vim

### TODO install essential packages
sudo apt-get install -y curl

### download and setup dotfiles
git clone https://github.com/paraschas/dotfiles.git
ln -s -b dotfiles/.bash_profile .
ln -s -b dotfiles/.bashrc .
ln -s -b dotfiles/.bashrc_custom .
#ln -s -f dotfiles/.vim .

### Node.js
# Install nvm: node-version manager
# https://github.com/creationix/nvm
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap
### </Node.js>
