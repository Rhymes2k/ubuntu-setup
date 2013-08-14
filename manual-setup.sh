#!/bin/bash

# manual-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# a shell script run manually to bootstrap a Debian 7 desktop system.
# a more extensive setup script is downloaded with git clone and
# automatically run afterwards.

# add user dp to the sudoers file. I don't think it's that dangerous.
sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) ALL/' /etc/sudoers

# backup previous sources.list
mv -v /etc/apt/sources.list /etc/apt/sources.list.backup

# create new sources.list
wget -nv https://raw.github.com/paraschas/debian-desktop-setup/master/sources.list
mv -v sources.list /etc/apt/

# resynchronize the package index files
sudo apt-get update
#sudo apt-get -q update

# install the newest versions of all packages currently installed on the system
sudo apt-get upgrade -y

# install git
sudo apt-get install -y git

# download and run setup
if [ -d debian-desktop-setup ]; then
    mv -iv debian-desktop-setup debian-desktop-setup.backup
fi
git clone https://github.com/paraschas/debian-desktop-setup.git
./debian-desktop-setup/setup.sh
