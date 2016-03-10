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
[[ -d dotfiles ]] && mv -iv dotfiles dotfiles.backup

git clone https://github.com/paraschas/dotfiles.git

[[ -f .ackrc ]] && mv -iv .ackrc .ackrc.backup
[[ -f .bash_aliases ]] && mv -iv .bash_aliases .bash_aliases.backup
[[ -f .bash_profile ]] && mv -iv .bash_profile .bash_profile.backup
[[ -f .bashrc ]] && mv -iv .bashrc .bashrc.backup
[[ -f .inputrc ]] && mv -iv .inputrc .inputrc.backup
[[ -f .octaverc ]] && mv -iv .octaverc .octaverc.backup
[[ -f .profile ]] && mv -iv .profile .profile.backup
[[ -f .vimperatorrc ]] && mv -iv .vimperatorrc .vimperatorrc.backup
[[ -f .tmux.conf ]] && mv -iv .tmux.conf .tmux.conf.backup

ln -s -f dotfiles/ackrc .ackrc
ln -s -f dotfiles/bash_aliases .bash_aliases
ln -s -f dotfiles/bash_profile .bash_profile
ln -s -f dotfiles/bashrc .bashrc
ln -s -f dotfiles/inputrc .inputrc
ln -s -f dotfiles/octaverc .octaverc
ln -s -f dotfiles/profile .profile
ln -s -f dotfiles/vimperatorrc .vimperatorrc
ln -s -f dotfiles/tmux.conf .tmux.conf

[[ -f .bashrc_custom ]] && mv -iv .bashrc_custom .bashrc_custom.backup

cp -iv dotfiles/bashrc_custom .bashrc_custom

# .gitconfig
[[ -f .gitconfig ]] && mv -iv .gitconfig .gitconfig.backup
cp -iv dotfiles/gitconfig .gitconfig
echo -e "\n[push]\n    default = simple" >> .gitconfig

# IPython
if [ -f .ipython/profile_default/ipython_config.py ]; then
    mv -iv .ipython/profile_default/ipython_config.py .ipython/profile_default/ipython_config.py.backup
fi
mkdir -p .ipython/profile_default/
ln -s -f dotfiles/.ipython/profile_default/ipython_config.py
################################################################################


# Vim
################################################################################
[[ -d .vim ]] && mv -iv .vim .vim.backup
[[ -f .vimrc ]] && mv -iv .vimrc .vimrc.backup
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
################################################################################
# https://github.com/rupa/z
while true; do
    echo ""
    read -p "do you want to setup z for Bash? (y/n): " SETUP_Z_ANSWER
    case $SETUP_Z_ANSWER in
        [Yy]* )
            cd
            # create $HOME/repositories/ directory
            mkdir -v repositories
            cd repositories
            git clone https://github.com/rupa/z.git
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
# TODO
# improve and verify
################################################################################
root_customization() {
    sudo mv -iv /root/dotfiles /root/dotfiles.backup
    sudo cp -iv -r /home/$SCRIPT_USER/dotfiles /root/
    sudo mv -iv /root/.bashrc /root/.bashrc.backup
    sudo ln -s -f dotfiles/bashrc /root/.bashrc
    sudo mv -iv /root/.vim /root/.vim.backup
    sudo cp -iv -r /home/$SCRIPT_USER/.vim /root/
    sudo mv -iv /root/.vimrc /root/.vimrc.backup
    sudo ln -s -f dotfiles/vimrc /root/.vimrc
    # TODO
    # create a symlink from /root/repositories/ to $HOME/repositories/
}
while true; do
    echo ""
    read -p "do you want to install customizations for the root account? (y/n): " ROOT_CUSTOMIZATION
    case $ROOT_CUSTOMIZATION in
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
