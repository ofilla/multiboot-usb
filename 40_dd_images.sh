#!/bin/bash

source config
source check_preconditions.sh
source functions_formatting.sh

partnumber=2
umount "$DEV"* 2> /dev/null

for iso in $(ls "$dd_isodir")
do
	echo "making $iso partition bootable ..."
	isohybrid --partok "$dd_isodir/$iso"
	echo -n "copying $iso via dd ... "
	dd if="$dd_isodir/$iso" of="$DEV$partnumber" bs=1M &> /dev/null || abort "dd failed" 4
	sync
	echo done
	partnumber=$(($partnumber + 1))
done

umount "$DEV"* 2> /dev/null

# re-create hybrid mbr
gdisk "$DEV" > /dev/null <<EOF
r
h
1
y
83
y
n
w
y
EOF

sync
