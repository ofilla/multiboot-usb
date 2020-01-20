#!/bin/bash

if [[ -z "$ARGV" ]]; then
	# if ARGV is unset: set to arguments
	ARGV=( $@ )
fi

source config
export ARGV

for file in $(ls ??_*.sh); do
	echo "============ start: $file"
	source "$file"
	echo "============ finished: $file"
done

if [[ "$FS" == *"fat" ]]; then
	which fatattr &> /dev/null || alias fatattr='./fatattr'
	echo "use fatattr instead of chmod"
	CHMOD="fatattr +hsr -a"
else
	CHMOD="chmod o+r"
fi

mount "${DEV}1" "$MOUNTPOINT"
find "$MOUNTPOINT" -type f -print0 | xargs -0 $CHMOD "$MOUNTPOINT/"*
find "$MOUNTPOINT" -type d -print0 | xargs -0 chmod o+x
umount "$MOUNTPOINT"

echo "all done"
