#!/bin/bash

# setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# configure an Ubuntu 14.04 LTS system


# TODO
# separate code for a desktop and a server system
#     packages
#     Vim plugins


# verify that the computer is running a Debian derivative
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! command -v dpkg &> /dev/null; then
    echo "this script is meant to be run on an Ubuntu system"
    exit 1
fi


# store the username
SCRIPT_USER=$USER


# option to run apt-get update and apt-get upgrade
update_and_upgrade() {
    # resynchronize the package index files
    sudo apt-get update

    # install the newest versions of all packages currently installed on the system
    sudo apt-get upgrade
}

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


# install git
sudo apt-get install -y git

# download the repository for local access
[[ -d ubuntu-setup ]] && mv -iv ubuntu-setup ubuntu-setup.backup
git clone https://github.com/paraschas/ubuntu-setup.git


# install ssh
sudo apt-get install -y ssh

# install curl
sudo apt-get install -y curl

# install tree
sudo apt-get install -y tree

# install xclip
sudo apt-get install -y xclip


# Fail2ban
# http://www.fail2ban.org/
while true; do
    echo ""
    read -p "do you want to install Fail2ban? (y/n): " INSTALL_FAIL2BAN
    case $INSTALL_FAIL2BAN in
        [Yy]* )
            sudo apt-get install -y fail2ban
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


# dotfiles
if [ -d dotfiles ]; then
    mv -iv dotfiles dotfiles.backup
fi
# TODO
# replace "if then" checks with the following format:
#[[ -d dotfiles ]] && mv -iv dotfiles dotfiles.backup

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
if [ -f .inputrc ]; then
    mv -iv .inputrc .inputrc.backup
fi
if [ -f .ackrc ]; then
    mv -iv .ackrc .ackrc.backup
fi

ln -s -f dotfiles/.bashrc .
ln -s -f dotfiles/.bash_aliases .
ln -s -f dotfiles/.bash_profile .
cp -iv dotfiles/.bashrc_custom .
ln -s -f dotfiles/.gitignore .
cp -iv dotfiles/.gitconfig .
ln -s -f dotfiles/.vimperatorrc .
ln -s -f dotfiles/.inputrc .
ln -s -f dotfiles/.ackrc .
# /dotfiles


# Vim
sudo apt-get install -y vim

# backup
if [ -d .vim ]; then
    mv -iv .vim .vim.backup
fi
ln -s -f dotfiles/.vimrc .

# setup Vundle
# https://github.com/gmarik/Vundle.vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install configured bundles
vim +BundleInstall +qall
# /Vim


# tmux
sudo apt-get install -y tmux
ln -s -f dotfiles/.tmux.conf .


# /data/ directory
data_directory() {
    cd /
    # create /data directory
    sudo mkdir -v data
    sudo chown -v $SCRIPT_USER:$SCRIPT_USER data
    # link /data directory to /d/
    sudo ln -v -s /data /d
}
while true; do
    echo ""
    read -p "do you want to create the /data directory? (y/n): " DATA_DIRECTORY_ANSWER
    case $DATA_DIRECTORY_ANSWER in
        [Yy]* )
            data_directory
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
# / /data directory


# setup z
# https://github.com/rupa/z
setup_z() {
    cd
    # create $HOME/repositories/ directory
    mkdir -v repositories
    cd repositories
    git clone https://github.com/rupa/z.git
}
while true; do
    echo ""
    read -p "do you want to setup z for Bash? (y/n): " SETUP_Z_ANSWER
    case $SETUP_Z_ANSWER in
        [Yy]* )
            setup_z
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
# /setup z


# setup development tools
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
# /setup development tools


# root customization
root_customization() {
    sudo mv -iv /root/dotfiles /root/dotfiles.backup
    sudo cp -iv -r /home/$SCRIPT_USER/dotfiles /root/
    sudo mv -iv /root/.bashrc /root/.bashrc.backup
    sudo ln -s -f dotfiles/.bashrc /root/
    sudo mv -iv /root/.vim /root/.vim.backup
    sudo cp -iv -r /home/$SCRIPT_USER/.vim /root/
    sudo mv -iv /root/.vimrc /root/.vimrc.backup
    sudo ln -s -f dotfiles/.vimrc /root/
    # TODO
    # create a symlink from /root/repositories/ to $HOME/repositories/
}
while true; do
    echo ""
    read -p "do you want to install customizations for the root account? (y/n): " ROOT_CUSTOMIZATION_ANSWER
    case $ROOT_CUSTOMIZATION_ANSWER in
        [Yy]* )
            root_customization
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
# /root customization


echo ""
echo "system customization successful"
