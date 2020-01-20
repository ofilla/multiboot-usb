#!/bin/bash

source config
source check_preconditions.sh

umount "${DEV}1" 2> /dev/null
mkdir -p "$iso_mountpoint"
mount "${DEV}1" "$MOUNTPOINT"

for iso in $(ls "$extracted_isodir/"*.iso 2> /dev/null | sed "s!^$extracted_isodir/!!")
do
	echo "found $iso"
	
	dirname="${iso%.iso}"
	dirname="$(echo "$dirname" | sed -e 's/[- ]/_/g' -e 's/[^A-Za-z0-9_]//g')"
	dest="$MOUNTPOINT$EXTRACTED_ISODIR/$dirname"

	if [[ -d "$dest" ]]; then
		# dir exists
		# do not do anything
		# assume that this image is completely copied yet
		continue
	fi
	
	mkdir -p "$dest"
	
	mount -t iso9660 -o ro "$extracted_isodir/$iso" "$iso_mountpoint"
	
	echo "  copying ..."
	cp -Pr "$iso_mountpoint/"* "$dest/"
	if [[ -n "$(ls -A "$iso_mountpoint" | grep '^\.')" ]]; then
		# found hidden files
		cp -Pr "$iso_mountpoint"/.??* "$dest/"
	fi
	
	umount -lf "$iso_mountpoint"
	echo " copied to $dirname"
done

rmdir "$iso_mountpoint"

sync
umount -l "${DEV}1"
