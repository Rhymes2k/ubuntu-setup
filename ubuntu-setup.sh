#!/bin/bash

# ubuntu-setup.sh
# configure an Ubuntu or Kubuntu 16.04 LTS system

# Dimitrios Paraschas (paraschas@gmail.com)


# verify that the computer is running a Debian derivative
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
    DATE_TIME=$(date +%Y-%m-%d_%H:%M:%S)

    if [ -d "$TARGET" ] || [ -f "$TARGET" ]; then
        if [ ! -L "$TARGET" ]; then
            mv -i -v "$TARGET" "$TARGET"\.backup\."$DATE_TIME"
        fi
    fi
}


# create a symbolic link of a directory or file in dotfiles
link_dotfiles() {
    TARGET="$1"

    # the argument starts with a dot
    if [ "${TARGET:0:1}" == "." ] && [ ! -d dotfiles/"$TARGET" ] && [ ! -f dotfiles/"$TARGET" ]; then
        TARGET_WITHOUT_DOT="${TARGET:1}"

        ln -s -f -v $HOME/dotfiles/"$TARGET_WITHOUT_DOT" ./\."$TARGET_WITHOUT_DOT"
    else
        ln -s -f -v $HOME/dotfiles/"$TARGET" .
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


remove_packages() {
    sudo apt-get purge -y klipper kubuntu-web-shortcuts
}

install_standard_packages() {
    sudo apt-get install -y ack-grep curl dos2unix git p7zip-full p7zip-rar ssh tmux tree unrar vim-gtk xclip
}

install_desktop_packages() {
    sudo apt-get install -y goldendict kdiff3 keepassx parcellite
}

if [ "$SUPERUSER_RIGHTS" == "y" ]; then
    yes_no_question "Do you want to setup a selection of packages?"
    if [ $? -eq 1 ]; then
        remove_packages

        install_standard_packages
    fi

    yes_no_question "Is this a desktop system?"
    if [ $? -eq 1 ]; then
        install_desktop_packages
    fi

    yes_no_question "Is this a server system?"
    # install Fail2ban, setup unattended security upgrades
    if [ $? -eq 1 ]; then
        sudo apt-get install -y unattended-upgrades fail2ban
        sudo dpkg-reconfigure unattended-upgrades
    fi
fi


# dotfiles
################################################################################

backup_datetime dotfiles

git clone https://github.com/paraschas/dotfiles.git

backup_datetime .ackrc
backup_datetime .bash_extensions
backup_datetime .bash_profile
backup_datetime .bashrc
backup_datetime .inputrc
backup_datetime .octaverc
backup_datetime .profile
backup_datetime .vimperatorrc
backup_datetime .tmux.conf

link_dotfiles .ackrc
link_dotfiles .bash_extensions
link_dotfiles .bash_profile
link_dotfiles .bashrc
link_dotfiles .inputrc
link_dotfiles .octaverc
link_dotfiles .profile
link_dotfiles .vimperatorrc
link_dotfiles .tmux.conf

backup_datetime .bashrc_local
cp -i -v dotfiles/bashrc_local .bashrc_local

# .gitconfig
backup_datetime .gitconfig
cp -i -v dotfiles/gitconfig .gitconfig

# IPython
backup_datetime .ipython/profile_default/ipython_config.py
mkdir -p .ipython/profile_default/
link_dotfiles .ipython/profile_default/ipython_config.py
################################################################################


# Vim
################################################################################
backup_datetime .vim
backup_datetime .vimrc

cp -r -i -v dotfiles/vim .vim
link_dotfiles .vimrc

# setup Vundle
# https://github.com/VundleVim/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

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
    mkdir -p -v $HOME/repositories

    backup_datetime $HOME/repositories/z

    git clone https://github.com/rupa/z.git $HOME/repositories/z
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
