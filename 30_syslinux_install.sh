#!/bin/bash

echo 'creating BOOTUSB partition ...'
mkfs.vfat -n BOOTUSB ${DEV}1

echo 'copying data'
mount ${DEV}1 /mnt
mkdir /mnt/boot
cp -r /usr/lib/syslinux /mnt/boot
umount /mnt

echo 'installing syslinux'
syslinux -ir -d boot/syslinux ${DEV}1
