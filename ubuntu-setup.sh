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


cd $HOME


# global variables
SCRIPT_USER=$USER
echo "you are logged in as user $SCRIPT_USER"


yes_no_question() {
    while true; do
        read -e -p "$1 (y/n): " YES_NO_ANSWER
        case $YES_NO_ANSWER in
            [y]* )
                break
                ;;
            [n]* )
                break
                ;;
            * )
                echo "please enter \"y\" for yes or \"n\" for no"
                ;;
        esac
    done

    if [ "$YES_NO_ANSWER" == "y" ]; then
        return 1
    else
        return 0
    fi
}


# append the suffix ".backup" and the datetime to a directory or file name
backup_datetime() {
    TARGET="$1"
    DATE_TIME=`date +%Y-%m-%d_%H:%M:%S`

    if [ -d "$TARGET" ] || [ -f "$TARGET" ]; then
        if [ ! -L "$TARGET" ]; then
            mv -i -v "$TARGET" "$TARGET"\."backup"\."$DATE_TIME"
        fi
    fi
}


yes_no_question "Do you have superuser rights on this system?"
if [ $? -eq 1 ]; then
    SUPERUSER_RIGHTS="y"
else
    echo "Skipping commands that require superuser rights."
fi


if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to update and upgrade the system?"
    if [ $? -eq 1 ]; then
        sudo apt-get update && sudo apt-get upgrade
    fi
fi


remove_install_packages() {
    # remove packages
    sudo apt-get purge -y klipper

    # install packages
    sudo apt-get install -y ack-grep curl goldendict kdiff3 keepassx git parcellite ssh tmux tree vim xclip
}
if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to setup a selection of packages?"
    if [ $? -eq 1 ]; then
        remove_install_packages
    fi
fi


# Fail2ban
# http://www.fail2ban.org/
if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to install Fail2ban?"
    if [ $? -eq 1 ]; then
        sudo apt-get install -y fail2ban
    fi
fi


# dotfiles
################################################################################

backup_datetime dotfiles

git clone https://github.com/paraschas/dotfiles.git

backup_datetime .ackrc
backup_datetime .bash_aliases
backup_datetime .bash_profile
backup_datetime .bashrc
backup_datetime .inputrc
backup_datetime .octaverc
backup_datetime .profile
backup_datetime .vimperatorrc
backup_datetime .tmux.conf

ln -s -f dotfiles/ackrc .ackrc
ln -s -f dotfiles/bash_aliases .bash_aliases
ln -s -f dotfiles/bash_profile .bash_profile
ln -s -f dotfiles/bashrc .bashrc
ln -s -f dotfiles/inputrc .inputrc
ln -s -f dotfiles/octaverc .octaverc
ln -s -f dotfiles/profile .profile
ln -s -f dotfiles/vimperatorrc .vimperatorrc
ln -s -f dotfiles/tmux.conf .tmux.conf

backup_datetime .bashrc_custom

cp -iv dotfiles/bashrc_custom .bashrc_custom

# .gitconfig
backup_datetime .gitconfig
cp -iv dotfiles/gitconfig .gitconfig
echo -e "\n[push]\n    default = simple" >> .gitconfig

# IPython
backup_datetime .ipython/profile_default/ipython_config.py
mkdir -p .ipython/profile_default/
ln -s -f dotfiles/.ipython/profile_default/ipython_config.py
################################################################################


# Vim
################################################################################
backup_datetime .vim
backup_datetime .vimrc
ln -s -f dotfiles/vimrc .vimrc

# setup Vundle
# https://github.com/VundleVim/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install configured bundles
vim +BundleInstall +qall
################################################################################


create_data_directory() {
    sudo mkdir -v /data

    sudo chown -v $SCRIPT_USER:$SCRIPT_USER /data

    # create the symbolic link /d
    sudo ln -s -v /data /d
}
if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to create the /data directory?"
    if [ $? -eq 1 ]; then
        create_data_directory
    fi
fi


# z
# https://github.com/rupa/z
yes_no_question "Do you want to setup z for Bash?"
if [ $? -eq 1 ]; then
    mkdir -v $HOME/repositories

    git clone https://github.com/rupa/z.git $HOME/repositories
fi


# install the linux-headers and build-essential packages
if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to install the linux-headers and build-essential packages?"
    if [ $? -eq 1 ]; then
        sudo apt-get install module-assistant

        sudo m-a prepare
    fi
fi


# root customizations
root_customizations() {
    echo "not implemented yet"
}
if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to install customizations for the root account?"
    if [ $? -eq 1 ]; then
        root_customizations
    fi
fi


echo ""
echo "system customization successful"
