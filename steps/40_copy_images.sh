ISOPATH="$MOUNTPOINT$ISODIR"

mount "${DEV}1" "$MOUNTPOINT"

if [[ "$(ls "$memdisk_isodir/"*.iso 2> /dev/null)" != "" ]]; then
	mkdir -p "$ISOPATH"
fi

for iso in $(ls "$memdisk_isodir/"*.iso 2> /dev/null)
do
	echo -n "copying iso: "
	rsync -WLch --progress "$iso" "$ISOPATH"
	sync
done

echo 'copied iso files for memdisk method'

sync
umount -l "${DEV}1"
