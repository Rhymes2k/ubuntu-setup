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
if [ -f .vimperatorrc ]; then
    mv -iv .vimperatorrc .vimperatorrc.backup
fi

ln -s -f dotfiles/.bashrc .
ln -s -f dotfiles/.bash_profile .
cp -iv dotfiles/.bashrc_custom .
ln -s -f dotfiles/.gitignore .
cp -iv dotfiles/.gitconfig .
ln -s -f dotfiles/.vimperatorrc .
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
            # install linux headers, build-essential, and other packages
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

### Node.js
setup_node() {
    # install nvm: node-version manager
    # https://github.com/creationix/nvm
    curl https://raw.github.com/creationix/nvm/master/install.sh | sh

    # load nvm
    source $HOME/.nvm/nvm.sh
    # install and use the latest 0.10.x Node version
    nvm install 0.10
    nvm use 0.10

    # install jshint to allow checking of JavaScript code in vim
    # http://jshint.com/
    npm install -g jshint

    # install rlwrap to provide libreadline features with node
    # http://nodejs.org/api/repl.html#repl_repl
    sudo apt-get install -y rlwrap
}

while true; do
    echo ""
    read -p "do you want to setup Node.js development? (y/n): " SETUP_NODE_DEV
    case $SETUP_NODE_DEV in
        [Yy]* )
            setup_node
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
### /Node.js

### install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

### root customization
sudo mv -iv /root/dotfiles /root/dotfiles.backup
sudo cp -iv -r /home/$SCRIPT_USER/dotfiles /root/
sudo mv -iv /root/.bashrc /root/.bashrc.backup
sudo ln -s -f dotfiles/.bashrc /root/
sudo mv -iv /root/.vim /root/.vim.backup
sudo cp -iv -r /home/$SCRIPT_USER/.vim /root/
sudo mv -iv /root/.vimrc /root/.vimrc.backup
sudo ln -s -f dotfiles/.vimrc /root/
### /root customization

### install gdevilspie
while true; do
    echo ""
    read -p "do you want to install gdevilspie? (y/n): " INSTALL_GDEVILSPIE
    case $INSTALL_GDEVILSPIE in
        [Yy]* )
            sudo apt-get install gdevilspie
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

### install parcellite
while true; do
    echo ""
    read -p "do you want to install parcellite? (y/n): " INSTALL_PARCELLITE
    case $INSTALL_PARCELLITE in
        [Yy]* )
            sudo apt-get install parcellite
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

### install keepassx
while true; do
    echo ""
    read -p "do you want to install keepassx? (y/n): " INSTALL_KEEPASSX
    case $INSTALL_KEEPASSX in
        [Yy]* )
            sudo apt-get install keepassx
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

echo ""
echo "devops setup concluded successfully"
