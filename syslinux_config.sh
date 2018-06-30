#!/bin/bash

source config
source syslinux_config_functions

alias find_bootable_dirs="find $MOUNTPOINT/boot/* -maxdepth 0 -type d | grep -v 'syslinux$'"

mount ${DEV}1 $MOUNTPOINT

reset_config_files

for ROOTDIR in $(find_bootable_dirs)
do
    FILENAME=isolinux.cfg
    export ROOTDIR=$(sed "s!^$MOUNTPOINT!!" <<< "$ROOTDIR")
    for file in $(find $MOUNTPOINT$ROOTDIR -type f -name $FILENAME -print)
    do
	export file=$(sed "s!^$MOUNTPOINT/boot/!!" <<< $file)
    	echo "found $file"

	backup_original_config "$file"
    	load_isolinux_config "$ROOTDIR" "$file"
    done
done

sync
umount -l ${DEV}1
