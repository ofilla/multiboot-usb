#!/bin/bash

source config
source check_preconditions.sh

mount ${DEV}1 $MOUNTPOINT

##### reset syslinux.cfg
cat <<EOF > $MOUNTPOINT/boot/syslinux/syslinux.cfg
PATH /boot/syslinux/modules/bios
UI vesamenu.c32

MENU TITLE Multiboot-USB

INCLUDE $INCLUDEDIR/stdmenu.cfg
INCLUDE $INCLUDEDIR/powermenu.cfg
INCLUDE $INCLUDEDIR/$menufilename_load
INCLUDE $INCLUDEDIR/$menufilename_extract
EOF

umount ${DEV}1
