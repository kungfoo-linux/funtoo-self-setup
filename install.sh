#!/bin/bash

echo "proc /proc proc defaults 0 0
/dev/sda2 none swap defaults 0 0
/dev/sda3 / btrfs compress=lzo,autodefrag 0 0
/dev/sda1 /boot ext4 defaults 0 0
/dev/sda4 /.hidden btrfs compress=lzo,autodefrag 0 0
" > /etc/fstab

emerge --sync

#Add later on to allow changing of timezone via IP, GPS or manually
TZone=$(whiptail --title "What timezone is your device going to initially used?" --radiolist
"Timezones" 20 78 10
PST8PDT "Pacific Time Zone"
UTC "Coordinated Universal Time" 
3>&1 1>&2 2>&3)
#I'll add more later I am just lazy and this is no where near complete
#I don't want to use my time adding timezones at the moment.
#heck I might even just remove the option all together and use IP, GPS instead
#but no clue these are my notes 
ln -sf /usr/share/zoneinfo/$TZone /etc/localtime

#change in final script to ask how many total cores user has
#might even be able to just ask for model of NUC or CPU
#will look into that
#most NUCs that I've seen so far have 4 threads.
#echo 'MAKEOPTS="-j5"
#' > /etc/portage/make.conf
#NOTE ON PERVIOUS COMMENT
#will make different 'make.conf' files to download from github according to answer
#It seems like the best way to do it instead to echoing to the same file over and over
#it's not like one NUC of the same make and model is going to differ

#will add option to choose. just getting basics down first

curl https://raw.githubusercontent.com/TheDurtch/funtoo-self-setup/master/make.conf > /etc/portage/make.conf

#Might do the samething here as I did with make.conf
echo "# required by sys-auth/polkit-0.113::gentoo[-systemd]
# required by net-misc/networkmanager-1.0.12-r1::gentoo
# required by networkmanager (argument)
>=sys-auth/consolekit-0.4.6 policykit" > /etc/portage/package.unmask

echo "this next part might take a LONG time
go make yourself a drink or watch a movie.
either way come back in a few hours"
sleep 5

emerge -auDN @world



#when I get my NUC i'll look into a custom kernel build for most NUCs and maybe auto build for older NUCs or hope community will support them.
#emerge debian-sources

emerge boot-update

#WILL NEED TO CHECK IF NUC HAS EFI OR NOT
#WOULD PREFER TO USE EFI BOOTING IF POSSIBLE
#yes I know I'll have to change my partitioning
#I am writing this to work inside vmware I'll update it later for NUC when I get one
grub-install --target=i386-pc --no-floppy /dev/sda
boot-update

emerge linux-firmware networkmanager
rc-update add NetworkManager default
# nmtui <-- This is a command (I am adding this because I forgot why I had this here)
#will adjust wifi later just adding this here so I don't forget

rc-update add dhcpcd default

#Standard user has no reason to access or login to root or media users directly
#I will set up a user user for direct access (I actually find little reason to do this either other then to debug)
#There will be no ssh, telnet, tftp, or ftp the main way of transferring files would be rslsync {I got permission to use this software} 
#unless someone can give me a better idea of what to use, and if you do by all means open a ticket @ https://github.com/TheDurtch/funtoo-self-setup/issues and I will check over it
#But I need a detailed write up of why I should use that program and how it will be better then Resilio Sync

#Reason why I am using rslsync is it transfers things in chunks via torrent protocol with this you can add a bunch of music to your sync folder
#and it will send it to your NUC when ever both machines are on and connected to the Internet so you don't have to wait for it to sync
#e.g. if you are at Starbucks drive-thru or McD drive-thru, or if you are one of those lucky bastards who have Unlimited Data plans on your phone you could tether to it and sync then too


ROOTPASSWORD=$(date | md5sum)

echo "root:$ROOTPASSWORD" | chpasswd

mkdir -p /.hidden/backup /.hidden/home

useradd -b /.hidden/home -m -G audio,cdrom,usb,video media

sleep 1

MEDIAPASSWORD=$(date | md5sum)

echo "media:$MEDIAPASSWORD" | chpasswd

NEWPASSWORD=$(whiptail --passwordbox "Please enter your password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
#read -s -p "Enter Password: " NEWPASSWORD

compname=(whiptail --inputbox "What is your favorite Color?" 8 78 Blue --title "Example Dialog" 3>&1 1>&2 2>&3)

HOSTNAME=(echo $compname | tr -d '\n')

echo "hostname=$HOSTNAME" > /etc/conf.d/hostname

epro flavor workstation

epro mix-ins +audio +dvd +media +X +mediadevice-base +media-pro +mediaformat-audio-extra +mediaformat-video-extra +mediaformat-gfx-extra 

emerge --sync

emerge xorg-x11

#emerge xf86-input-evdev

#emerge sawfish 






exit
