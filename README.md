devops setup of a Debian 7 (Wheezy) system

run as root to setup sudo for the specified user
```sh
wget -N https://raw.github.com/paraschas/debian-setup/master/sudo-setup.sh && chmod +x sudo-setup.sh && ./sudo-setup.sh && rm -v sudo-setup.sh
```

run as the specified user
```sh
wget -N https://raw.github.com/paraschas/debian-setup/master/manual-setup.sh && chmod +x manual-setup.sh && ./manual-setup.sh && rm -v manual-setup.sh
```
