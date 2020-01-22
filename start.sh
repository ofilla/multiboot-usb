#!/bin/bash

source config

for file in $(ls ??_*.sh); do
	echo "start: $file"
	echo
	source "$file"
	echo
done

if [[ "$FS" == *"fat" ]]; then
	which fatattr &> /dev/null || alias fatattr='./fatattr'
	echo "use fatattr instead of chmod"
	CHMOD="fatattr +hsr -a"
else
	CHMOD="chmod o+r"
fi

mount $GRUBDEV "$MOUNTPOINT"
find "$MOUNTPOINT" -type f -print0 | xargs -0 $CHMOD "$MOUNTPOINT/"*
find "$MOUNTPOINT" -type d -print0 | xargs -0 chmod o+x
umount $GRUBDEV

partprobe
echo "all done"
