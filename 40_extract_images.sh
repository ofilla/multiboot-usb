#!/bin/bash

source config

mkdir -p $iso_mountpoint
mount ${DEV}1 $MOUNTPOINT

for iso in $(ls extracted_isos/*.iso 2> /dev/null)
do
    echo "found $iso"
    
    dirname=${iso%.iso}
    dirname=$(echo $dirname | sed -e 's/[- ]/_/g' -e 's/[^A-Za-z0-9_]//g')
    dest=$MOUNTPOINT/boot/$dirname

    if [[ -d $dest ]]; then # dir exists
	# do not do anything
	# assume that this image is completely copied yet
	continue
    fi
    
    mkdir $dest
    
    mount -t iso9660 -o ro $iso $iso_mountpoint
    echo "  copying ..."
    cp -Pr $iso_mountpoint/* $iso_mountpoint/.??* $MOUNTPOINT/boot/$dirname/
    
    umount -lf $iso_mountpoint
    echo " copied to $dirname"
done

rmdir $iso_mountpoint

sync
umount -l ${DEV}1
