Ubuntu/Kubuntu 14.04 LTS configuration
===

Configuration of an Ubuntu/Kubuntu system, and installation of my dotfiles.

run the configuration script:
```sh
wget -N https://github.com/paraschas/ubuntu-setup/raw/master/ubuntu-setup.sh && chmod +x ubuntu-setup.sh && ./ubuntu-setup.sh && rm -v ubuntu-setup.sh
```

TODO
---
replace "if then" checks with the following format:
```
[[ -d dotfiles ]] && mv -iv dotfiles dotfiles.backup
```

separate code for a desktop and a server system
```
packages
Vim plugins
```
