#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# script to configure a Debian 7 desktop

cd $HOME

# store the username
SCRIPT_USER=$USER

# TODO this should only run if the script is run directly
# resynchronize the package index files
#sudo apt-get update
#sudo apt-get -q update
# install the newest versions of all packages currently installed on the system
#sudo apt-get upgrade -y

# install ssh
sudo apt-get install -y ssh

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

if [ -f .bashrc ]; then
    mv -iv .bashrc .bashrc.backup
fi
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
sudo chown -v $SCRIPT_USER:$SCRIPT_USER data
sudo ln -v -s /data /d

### setup development tools
while true; do
    echo ""
    read -p "do you want to setup some development tools? (y/n): " SETUP_DEV_TOOLS
    case $SETUP_DEV_TOOLS in
        [Yy]* )
            sudo apt-get install module-assistant
            sudo m-a prepare
            break
            ;;
        [Nn]* )
            break
            ;;
        * )
            echo "please enter \"y\" for yes or \"n\" for no"
            ;;
    esac
done

### root customization
sudo mv -iv /root/.bashrc /root/.bashrc.backup
sudo ln -s -f dotfiles/.bashrc /root/
#sudo mv -iv /root/.bashrc_custom /root/.bashrc_custom.backup
#sudo cp -iv dotfiles/.bashrc_custom /root/
sudo mv -iv /root/.vim /root/.vim.backup
sudo ln -s -f dotfiles/.vim /root/
sudo mv -iv /root/.vimrc /root/.vimrc.backup
sudo ln -s -f dotfiles/.vimrc /root/
### /root customization
