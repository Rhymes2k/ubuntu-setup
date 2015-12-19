#!/bin/bash

# ubuntu-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# configure an Ubuntu or Kubuntu 14.04 LTS system


# verify that the computer is running a Debian derivative
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! command -v dpkg &> /dev/null; then
    echo "this script is meant to be run on an Ubuntu system"
    exit 1
fi


# store the username
SCRIPT_USER=$USER


# add the suffix ".backup" to the passed directory or file
dp_backup() {
    if [[ $1 == "" ]]; then
        printf "nothing to backup\n"
    else
        if [ -d $1 ] || [ -f $1 ]; then
            mv -iv $1 $1\.backup
        fi
    fi
}


# create a symbolic link of the passed directory or file residing in dotfiles
dp_link() {
    if [[ $1 == "" ]]; then
        printf "nothing to link\n"
    else
        ln -s -f dotfiles/$1 .
    fi
}


while true; do
    read -e -p "Do you want to apt-get update and upgrade the system? (y/n): " UPDATE_AND_UPGRADE_ANSWER
    case $UPDATE_AND_UPGRADE_ANSWER in
        [Yy]* )
            sudo apt-get update && sudo apt-get upgrade
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

sudo apt-get purge -y klipper
sudo apt-get install -y parcellite

# install git
sudo apt-get install -y git

# download the repository for local access
[[ -d ubuntu-setup ]] && mv -iv ubuntu-setup ubuntu-setup.backup
git clone https://github.com/paraschas/ubuntu-setup.git


# install useful packages
sudo apt-get install -y ssh curl tree xclip


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
################################################################################
link_to_dotfiles() {
    dp_backup dotfiles

    git clone https://github.com/paraschas/dotfiles.git

    dp_backup .bashrc
    dp_backup .bashrc_custom
    dp_backup .gitconfig
    dp_backup .vimperatorrc
    dp_backup .inputrc
    dp_backup .ackrc
    dp_backup .ipython/profile_default/ipython_config.py

    dp_link .bashrc
    dp_link .bash_aliases
    dp_link .bash_profile
    dp_link .gitignore
    dp_link .vimperatorrc
    dp_link .inputrc
    dp_link .ackrc

    # IPython configuration
    mkdir -p dotfiles/.ipython/profile_default/
    dp_link .ipython/profile_default/ipython_config.py

    cp -iv dotfiles/.bashrc_custom .

    cp -iv dotfiles/.gitconfig .
    echo -e "\n[push]\n    default = simple" >> .gitconfig
}
################################################################################


# Vim
################################################################################
sudo apt-get install -y vim

dp_backup .vim
dp_link .vimrc

# setup Vundle
# https://github.com/VundleVim/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install configured bundles
vim +BundleInstall +qall
################################################################################


# tmux
sudo apt-get install -y tmux
dp_link .tmux.conf


# /data/ directory
################################################################################
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
################################################################################


# z
################################################################################
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
################################################################################


# setup development tools
################################################################################
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
################################################################################


# root customization
################################################################################
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
################################################################################


echo ""
echo "system customization successful"
