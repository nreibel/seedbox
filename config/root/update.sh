#!/bin/sh
apt update && apt-get dist-upgrade -y
apt autoremove
apt clean
/root/flexget/bin/pip install --upgrade setuptools
/root/flexget/bin/pip install --upgrade flexget
/root/flexget/bin/pip install --upgrade transmission-rpc
reboot
