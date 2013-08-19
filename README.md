devops setup of a Debian 7 (Wheezy) desktop system

run as root if sudo is not installed
```sh
apt-get install sudo
```

run as root [TODO drop usage of root account]
```sh
cd $HOME

wget -nv -r https://raw.github.com/paraschas/debian-desktop-setup/master/manual-setup.sh && chmod +x manual-setup.sh && ./manual-setup.sh && rm -v manual-setup.sh
```
