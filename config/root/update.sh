#!/bin/sh
apt update && apt-get dist-upgrade -y
apt autoremove
apt autoclean
/root/flexget/bin/pip install --upgrade setuptools
/root/flexget/bin/pip install --upgrade flexget
reboot
