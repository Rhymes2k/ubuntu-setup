#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# setup a Debian 7 system

update_and_upgrade() {
    # resynchronize the package index files
    sudo apt-get update
    # install the newest versions of all packages currently installed on the system
    sudo apt-get upgrade
}
### option to run apt-get update and apt-get upgrade
while true; do
    read -e -p "Do you want to apt-get update and upgrade the system? (y/n): " UPDATE_AND_UPGRADE_ANSWER
    case $UPDATE_AND_UPGRADE_ANSWER in
        [Yy]* )
            update_and_upgrade
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

cd $HOME

# store the username
SCRIPT_USER=$USER

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
while true; do
    echo ""
    read -p "do you want to install Fail2ban? (y/n): " INSTALL_FAIL2BAN
    case $INSTALL_FAIL2BAN in
        [Yy]* )
            sudo apt-get install fail2ban
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
            # install linux headers, build-essential, and other packages
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

### Heroku toolbelt
heroku_toolbelt() {
    # https://toolbelt.heroku.com/debian
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
}
while true; do
    echo ""
    read -p "do you want to install Heroku toolbelt? (y/n): " HEROKU_TOOLBELT_ANSWER
    case $HEROKU_TOOLBELT_ANSWER in
        [Yy]* )
            heroku_toolbelt
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
### /Heroku toolbelt

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
echo "Debian setup successful"

# TODO
# create $HOME/repositories/ directory
# git clone z in it
# create a symlink from /root/repositories/ to $HOME/repositories/
