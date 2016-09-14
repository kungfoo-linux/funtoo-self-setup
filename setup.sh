#!/bin/bash

sgdisk --zap-all /dev/sda
#parted -s /dev/sda --script -- mklabel msdos
#parted -s /dev/sda mkpart primary 0% 1%
#parted -s /dev/sda mkpart primary 1% 4%
#parted -s /dev/sda mkpart primary 4% 75%
#parted -s /dev/sda mkpart primary 75% 100%
echo "o
n
p
1

+128M
n
p
2

+512M
t
2
82
n
p
3

+8G
n
p


w
" | fdisk /dev/sda

partprobe /dev/sda

mkfs.btrfs /dev/sda3
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.btrfs /dev/sda4

mkdir /mnt/funtoo
mount -o compress=lzo,autodefrag /dev/sda3 /mnt/funtoo

mkdir /mnt/funtoo/boot
mount /dev/sda1 /mnt/funtoo/boot

mkdir /mnt/funtoo/.hidden
mount -o compress=lzo,autodefrag /dev/sda4 /mnt/funtoo/.hidden

cd /mnt/funtoo
curl http://build.funtoo.org/funtoo-stable/x86-64bit/generic_64/funtoo-stable-openvz-latest.tar.xz | tar xJvpf -

cd /mnt/funtoo
mount -t proc none proc
mount --rbind /sys sys
mount --rbind /dev dev

cp -f /etc/resolv.conf /mnt/funtoo/etc/

#echo "please run <insert other scripts URL here> from inside the chroot"

env -i HOME=/root TERM=$TERM chroot . bash -l

curl https://raw.githubusercontent.com/TheDurtch/funtoo-self-setup/master/install.sh | bash

cd /mnt

umount -lR funtoo

reboot
