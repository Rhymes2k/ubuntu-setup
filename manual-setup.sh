#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# shell script to be run manually to bootstrap a Debian desktop system.
# a more extensive setup script is downloaded with git clone and run afterwards.

# add user dp to the sudoers file. I don't think it's that dangerous.
sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) ALL/' /etc/sudoers

# backup previous sources.list
mv -v /etc/apt/sources.list /etc/apt/sources.list.backup

# create new sources.list
wget -nv https://raw.github.com/paraschas/debian-desktop-setup/master/sources.list
mv -v sources.list /etc/apt/

# resynchronize the package index files
apt-get update

# install the newest versions of all packages currently installed on the system
apt-get upgrade -y

# install git
apt-get install -y git

# download and run setup
sudo -u dp git clone https://github.com/paraschas/debian-desktop-setup.git
sudo -u dp ./debian-desktop-setup/setup.sh
