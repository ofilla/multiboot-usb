#!/bin/bash

echo 'creating BOOTUSB partition ...'
mkfs.vfat -n BOOTUSB ${DEV}1

echo 'copying data'
mount ${DEV}1 $MOUNTPOINT
mkdir $MOUNTPOINT/boot
cp -r syslinux $MOUNTPOINT/boot
umount $MOUNTPOINT

echo 'installing syslinux'
syslinux -ir -d boot/syslinux ${DEV}1

echo 'installing MBR'
mount ${DEV}1 $MOUNTPOINT
dd conv=notrunc bs=440 count=1 if=/mnt/boot/syslinux/mbr/mbr.bin of=$DEV
umount $MOUNTPOINT

sync
