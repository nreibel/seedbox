#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

echo 'Update software'
apt update && apt -y dist-upgrade

echo 'Install new software'
apt install -y openvpn transmission-daemon minidlna samba python3 python3-dev python3-venv iptables-persistent

echo 'Install Flexget'
python3 -m venv ~/flexget
pushd ~/flexget
./bin/pip install wheel
./bin/pip install flexget transmissionrpc
popd

if [ ! -d /public ]; then
  echo 'Create public folder'
  mkdir /public
  chmod 777 /public
fi

# Solves a problem with MiniDLNA and iNotify
# if ! grep -q fs.inotify.max_user_watches /etc/sysctl.conf; then
#   echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf
#   sysctl -p
# fi

echo 'Set firewall rules'
iptables -F
iptables -A OUTPUT -m owner --uid-owner debian-transmission -d 192.168.1.0/24 -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner debian-transmission \! -o tun0 -j REJECT
iptables-save > /etc/iptables/rules.v4

ip6tables -F
ip6tables -A OUTPUT -m owner --uid-owner debian-transmission -d fe80::/64 -j ACCEPT
ip6tables -A OUTPUT -m owner --uid-owner debian-transmission \! -o tun0 -j REJECT
ip6tables-save > /etc/iptables/rules.v6

echo 'Copy all config files'
service transmission-daemon stop
service minidlna stop
service smbd stop
service openvpn stop

cp -v -R ./config/* /
systemctl daemon-reload

echo 'Install scripts and crontab'
chmod +x /root/vpn.sh
chmod +x /root/reload_minidlna.sh
chmod +x /root/update.sh

crontab < ./crontab

read -s -p 'Install OK, press Enter to reboot'
echo

reboot
