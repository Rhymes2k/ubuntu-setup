#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# shell script to be run manually to bootstrap a Debian desktop system.
# a complete setup script is downloaded with git clone and run afterwards.

# backup previous sources.list
mv -v /etc/apt/sources.list /etc/apt/sources.list.backup

# create new sources.list
wget -nv https://raw.github.com/paraschas/debian-desktop-setup/master/sources.list
mv -v sources.list /etc/apt/
rm -v sources.list

# resynchronize the package index files
apt-get update

# install the newest versions of all packages currently installed on the system
apt-get upgrade -y

# install git
apt-get install -y git

# download and run setup
#cd $HOME
#git clone https://github.com/paraschas/debian-desktop-setup.git
#./debian-desktop-setup/setup.sh
