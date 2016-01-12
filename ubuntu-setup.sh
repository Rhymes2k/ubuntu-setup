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


# compare version numbers
# http://stackoverflow.com/questions/4023830/bash-how-compare-two-strings-in-version-format
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}


while true; do
    read -e -p "Do you want to update and upgrade the system? (y/n): " UPDATE_AND_UPGRADE_ANSWER
    case $UPDATE_AND_UPGRADE_ANSWER in
        [Yy]* )
            # resynchronize the package index files
            sudo apt-get update
            # install the newest versions of all packages currently installed on the system
            sudo apt-get upgrade
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


# remove packages
sudo apt-get purge -y klipper

# install packages
sudo apt-get install -y curl git parcellite ssh tmux tree vim xclip


# download the repository for local access
[[ -d ubuntu-setup ]] && mv -iv ubuntu-setup ubuntu-setup.backup
git clone https://github.com/paraschas/ubuntu-setup.git


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
# TODO
# when was this version added?
# new setting added in git version ?
# get the git version
GIT_VERSION=`git --version | cut -d " " -f 3`
#echo $GIT_VERSION
GIT_BASE_VERSION="1.9.0"
vercomp $GIT_VERSION $GIT_BASE_VERSION
VERCOMP_RESULT=$?
if [ "$VERCOMP_RESULT" == 0 ] || [ "$VERCOMP_RESULT" == 1 ]; then
    echo "current git version $GIT_VERSION is at least $GIT_BASE_VERSION"
    echo "setting push.default in .gitconfig to simple"
    echo -e "\n[push]\n    default = simple" >> .gitconfig
fi

[[ -f .gitignore ]] && mv -iv .gitignore .gitignore.backup
ln -s -f dotfiles/data/.gitignore .

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
