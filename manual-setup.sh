#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# bootstrap a Debian 7 system
# A more extensive setup script is downloaded with git and run automatically.

### verify that the machine is running Debian
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! command -v dpkg &> /dev/null; then
    echo "this script is meant to be run on a Debian machine"
    exit 1
fi

replace_sources_list() {
    # backup previous sources.list
    sudo mv -v /etc/apt/sources.list /etc/apt/sources.list.backup
    # create new sources.list
    wget -N https://raw.github.com/paraschas/debian-setup/master/sources.list
    sudo mv -v sources.list /etc/apt/
}
### option to update sources.list
while true; do
    read -e -p "Do you want to replace the sources.list? (y/n): " REPLACE_SOURCES_LIST_ANSWER
    case $REPLACE_SOURCES_LIST_ANSWER in
        [Yy]* )
            replace_sources_list
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

# install git
sudo apt-get install -y git

# download and run setup
if [ -d debian-setup ]; then
    mv -iv debian-setup debian-setup.backup
fi
git clone https://github.com/paraschas/debian-setup.git
./debian-setup/setup.sh
