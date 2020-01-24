#!/bin/bash

if [[ -n $1 ]]; then
	if [[ $1 == /dev/*[^0-9] ]]; then
		MULTIBOOT_DEV=$1
	else
		echo "invalid destination device" >&2
		exit 1
	fi
fi

source config
PATH=$PATH:$(pwd)/lib

for file in lib/*.sh
do
	source "$file"
done


for file in steps/??_*.sh
do
	echo "start: $file"
	echo
	source "$file"
	echo
done

mount $GRUBDEV "$MOUNTPOINT"
find "$MOUNTPOINT" -type f -print0 | xargs -0 chmod o+r
find "$MOUNTPOINT" -type d -print0 | xargs -0 chmod o+rx
umount -rl "$MOUNTPOINT"

partprobe
echo "all done"
