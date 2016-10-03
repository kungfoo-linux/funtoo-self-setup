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
#I'll add more later I am just lazy and this is no where near complete
#I don't want to use my time adding timezones at the moment.
#heck I might even just remove the option all together and use IP, GPS instead
#but no clue these are my notes 
ln -sf /usr/share/zoneinfo/PST8PDT /etc/localtime

#change in final script to ask how many total cores user has
#might even be able to just ask for model of NUC or CPU
#will look into that
#most NUCs that I've seen so far have 4 threads.
echo 'MAKEOPTS="-j5"
' > /etc/portage/make.conf
#NOTE ON PERVIOUS COMMENT
#will make different 'make.conf' files to download from github according to answer
#It seems like the best way to do it instead to echoing to the same file over and over
#it's not like one NUC of the same make and model is going to differ

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
emerge debian-sources

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

#Ask user for hostname

echo NUC > /etc/conf.d/hostname

#ask user for password
read -s -p "Enter Password: " NEWPASSWORD
echo "$USER:$NEWPASSWORD" | chpasswd
#Thinking about changing root password to "md5sum $(date)" and make a user profile to ask for username a password for but that will be added later.

mkdir -p /.hidden/backup

exit
