# Torrent/VPN/Media server on a Odroid HC1 using Ubuntu 18.04 LTS
This script will set up automatic download of TV shows using [Flexget](https://flexget.com), setting up a public folder for streaming to a TV. The TV shows are fetched through a RSS feed such as [ShowRSS](https://showrss.info)

A subscription to a VPN is required. Firewall rules ensure that torrents are downloaded only through the VPN, and cron jobs check the connexion status regularly 

Flexget is set to execute every hour, this can be changed in the cron table.

## Create a flashable Ubuntu 18.04 LTS bootable SD card
`dd if=<image.img> of=/dev/sdX status=progress`
* replace image.img with the path to Ubuntu 18.04 LTS img file
* /dev/sdX points to the SD card, as shown with 'fdisk -l'

## Login and prepare the HC1
1. Login to the HC1 with `ssh root@odroid`
1. Set the root password by typing `sudo passwd`
1. Make a /public folder and modify `/etc/fstab` to mount the hard drive there

## Get the files
1. `git clone <repository address>`
1. `cd seedbox`

## Set up your VPN and Flexget
* Edit `config/root/.flexget/config.yml` to set your RSS feed
* Edit `config/etc/openvpn/` to set up your own VPN

## Run Install
1. Set `install.sh` as executable by typing `chmod +x install.sh`
1. Execute `./install.sh`

## Check install
If install is successfull, the HC1 will reboot.
To check if everything is ok, SSH as root and check :
* By typing `ip a`, `tun0` is connected
* By typing `iptables -L`, the firewall rules are present
* You can access `/public` via samba or sftp

## Additionnal info
* Run `/root/update.sh` periodically to update Ubuntu and Flexget
* Enable auto update by typing `crontab -e` and uncommenting the last line
* Run `/root/reload_minidlna.sh` if you need to rebuild Minidlna's database
* The web-interface can be accessed locally with http://odroid:9091/transmission/web/
