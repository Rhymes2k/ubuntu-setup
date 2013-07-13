#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# shell script to be run manually to bootstrap a Debian desktop system.
# a complete setup script is downloaded with git clone and run afterwards.

# backup previous sources.list
mv /etc/apt/sources.list /etc/apt/sources.list.backup

# create new sources.list
#echo "### Debian main repository
#deb http://ftp.de.debian.org/debian/ wheezy main contrib non-free
#deb-src http://ftp.de.debian.org/debian/ wheezy main contrib non-free
#
#### Debian update repository
#deb http://security.debian.org/ wheezy/updates main contrib non-free
#deb-src http://security.debian.org/ wheezy/updates main contrib non-free" > /etc/apt/sources.list
wget https://raw.github.com/paraschas/debian-desktop-setup/master/sources.list > /etc/apt/sources.list

# resynchronize the package index files
#apt-get update

# install the newest versions of all packages currently installed on the system
#apt-get upgrade -y

# install git
#apt-get install -y git

# download and run setup
#cd $HOME
#git clone https://github.com/paraschas/debian-desktop-setup.git
#./debian-desktop-setup/setup.sh
