#!/bin/bash

source config
source check_preconditions.sh

sleep 10
umount -lf "${DEV}1" 2> /dev/null
echo "creating partition $LABEL ..."

function create_dirs() {
	sleep 10
	echo 'copying data'
	mount "${DEV}1" "$MOUNTPOINT"
	mkdir -p "$MOUNTPOINT/boot"
	cp -r syslinux "$MOUNTPOINT/boot"
	umount "$MOUNTPOINT"
}

echo 'installing syslinux'
if [[ "$FS" == 'vfat' ]]; then
	mkfs.vfat -F32 -n "$LABEL" "${DEV}1"
	create_dirs
	syslinux -ir -d boot/syslinux "${DEV}1"
elif [[ "$FS" == 'ext'? ]]; then
	mkfs.$FS -L "$LABEL" "${DEV}1"
	create_dirs
	mount "${DEV}1" "$MOUNTPOINT"
	extlinux -ir "$MOUNTPOINT/boot/syslinux"
else
	echo "FS currently not supported: $FS" >&2
	exit 4
fi

echo 'installing MBR'
mount "${DEV}1" "$MOUNTPOINT"
dd conv=notrunc bs=440 count=1 if=/mnt/boot/syslinux/mbr/mbr.bin of="$DEV"
umount -lf "${DEV}1"

sync
