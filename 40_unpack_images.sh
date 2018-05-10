#!/bin/bash

iso_mountpoint=/tmp/iso
mkdir -p $iso_mountpoint

MOUNTPOINT=/media/of/BOOTUSB

for iso in *.iso
do
    echo "found $iso"
    
    dirname=${iso%.iso}
    dirname=$(echo $dirname | sed -e 's/[- ]/_/g' -e 's/[^A-Za-z0-9_]//g')
    dest=$MOUNTPOINT/boot/$dirname

    [[ -d $dest ]] && continue
    mkdir $dest
    
    mount -t iso9660 -o ro $iso $iso_mountpoint
    echo "  copying ..."
    cp -Lr $iso_mountpoint/* $iso_mountpoint/.??* $MOUNTPOINT/boot/$dirname/
    umount -lf $iso_mountpoint

    echo " copied to $dirname"
done

rmdir $iso_mountpoint
