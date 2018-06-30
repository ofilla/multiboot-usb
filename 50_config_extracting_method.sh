#!/bin/bash

source config
source extracting_functions.sh

alias find_bootable_dirs="find $MOUNTPOINT$EXTRACTED_ISODIR/* -maxdepth 0 -type d"

mount ${DEV}1 $MOUNTPOINT

reset_config_files

for ROOTDIR in $(find_bootable_dirs)
do
    FILENAME=isolinux.cfg
    export ROOTDIR=$(sed "s!^$MOUNTPOINT!!" <<< "$ROOTDIR")
    for file in $(find $MOUNTPOINT$ROOTDIR -type f -name $FILENAME -print)
    do
	export file=$(sed "s!^$MOUNTPOINT$EXTRACTED_ISODIR/!!" <<< $file)
    	echo "found $file"

	backup_original_config "$file"
    	load_isolinux_config "$ROOTDIR" "$file"
    done
done

sync
umount -l ${DEV}1
