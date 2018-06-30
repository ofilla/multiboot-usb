#!/bin/bash

source config
source extracting_functions.sh

mount ${DEV}1 $MOUNTPOINT

echo 'reset menufile for extracted images'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg\n" > $menufile

for ROOTDIR in $(find $MOUNTPOINT$EXTRACTED_ISODIR/* -maxdepth 0 -type d)
do
    FILENAME=isolinux.cfg
    export ROOTDIR=$(sed "s!^$MOUNTPOINT!!" <<< "$ROOTDIR")
    echo $ROOTDIR
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
