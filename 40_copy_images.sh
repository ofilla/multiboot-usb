#!/bin/bash

source config
source check_preconditions.sh

ISOPATH="$MOUNTPOINT$ISODIR"

mount ${DEV}1 $MOUNTPOINT

if [[ "$(ls $copy_isodir/*.iso)" != "" ]]; then
    mkdir -p $ISOPATH
fi

for iso in $(ls $copy_isodir/*.iso 2> /dev/null)
do
    echo -n "copying iso: "
    rsync -WLch --progress $iso $ISOPATH
    sync
done

echo 'copied iso files'

sync
umount -l ${DEV}1
