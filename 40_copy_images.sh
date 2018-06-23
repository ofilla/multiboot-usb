#!/bin/bash

ISODIR='/boot/iso'
ISOPATH="$MOUNTPOINT$ISODIR"

mount ${DEV}1 $MOUNTPOINT

mkdir -p $ISOPATH

for iso in *.iso
do
    echo -n "copying iso: "
    rsync -WLch --progress $iso $ISOPATH
    sync
done

echo 'copied iso files'

sync
umount -l ${DEV}1
