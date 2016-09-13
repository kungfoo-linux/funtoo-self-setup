#!/bin/bash

echo "proc /proc proc defaults 0 0
/dev/sda2 none swap defaults 0 0
/dev/sda3 / btrfs compress=lzo,autodefrag 0 0
/dev/sda1 /boot ext4 defaults 0 0
/dev/sda4 /.hidden btrfs compress=lzo,autodefrag 0 0
" > /etc/fstab

emerge --sync

#change in final script to ask basic TZ or for manual input
ln -sf /usr/share/zoneinfo/PST8PDT /etc/localtime

#change in final script to ask how many total cores user has
#might even be able to just ask for model of NUC or CPU
#will look into that
echo 'MAKEOPTS="-j3"
' > /etc/portage/make.conf
#NOTE ON PERVIOUS COMMENT
#will make different 'make.conf' files to download from github accorrding to anwser
#It seems like the best way to do it instead to echoing to the same file over and over
#it's not like one NUC of the same make and model is going to differ

echo "this next part might take a LONG time
go make yourself a drink or watch a movie.
either way come back in a few hours"
sleep 5

emerge -auDN @world

emerge boot-update

#WILL NEED TO CHECK IF NUC HAS EFI OR NOT
#WOULD PREFER TO USE EFI BOOTING IF POSSIBLE
#yes I know I'll have to change my partitioning
#I am writing this to work inside vmware I'll update it later for NUC when I get one
grub-install --target=i386-pc --no-floppy /dev/sda
boot-update

emerge linux-firmware networkmanager
rc-update add NetworkManager default
# nmtui
#will addjust wifi later just adding this here so I don't forget

rc-update add dhcpcd default

#Ask user for hostname

echo NUC > /etc/conf.d/hostname

#ask user for password
passwd

exit