umount "$DEV"* 2> /dev/null

for iso in $(ls "$dd_isodir")
do
	echo "making $iso partition bootable ..."
	isohybrid --partok "$dd_isodir/$iso"
	echo -n "copying $iso via dd ... "
	dd if="$dd_isodir/$iso" of="$DEV$partnumber" bs=1M oflag=sync conv=fsync status=none
	[[ $? -gt 0 ]] && abort "dd failed" 4  # abort if dd failed
	sync
	echo "done"
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
