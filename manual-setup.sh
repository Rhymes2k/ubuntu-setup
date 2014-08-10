#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# bootstrap an Ubuntu 14.04.x LTS system
# A more extensive setup script is downloaded with git and run automatically.


### verify that the machine is running a Debian derivative
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! command -v dpkg &> /dev/null; then
    echo "this script is meant to be run on an Ubuntu machine"
    exit 1
fi

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
if [ -d ubuntu-setup ]; then
    mv -iv ubuntu-setup ubuntu-setup.backup
fi
git clone https://github.com/paraschas/ubuntu-setup.git
./ubuntu-setup/setup.sh
