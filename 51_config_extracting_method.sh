#!/bin/bash

source config
source check_preconditions.sh
source functions_extracting.sh

mount ${DEV}1 $MOUNTPOINT

echo 'reset menufile for extracted images'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg" > $menufile

for ROOTDIR in $(find $MOUNTPOINT$EXTRACTED_ISODIR/* -maxdepth 0 -type d)
do
    FILENAME=isolinux.cfg
    ROOTDIR=$(sed "s!^$MOUNTPOINT!!" <<< "$ROOTDIR")
    for file in $(find $MOUNTPOINT$ROOTDIR -type f -name $FILENAME -print)
    do
	file=$(sed "s!^$MOUNTPOINT$EXTRACTED_ISODIR/!!" <<< $file)
    	echo "found $file"

	backup_original_config "$file"
    	load_isolinux_config "$file" "$ROOTDIR"
    done
done

sync
umount -l ${DEV}1
