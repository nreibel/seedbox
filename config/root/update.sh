#!/bin/sh

# Update OS and packages
apt update
apt-get dist-upgrade -y
apt autoremove
apt clean

# Update Flexget
/root/flexget/bin/pip install --upgrade setuptools
/root/flexget/bin/pip install --upgrade flexget
/root/flexget/bin/pip install --upgrade transmission-rpc

# Reboot
reboot
