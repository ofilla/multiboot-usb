CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
ISOPATH="$MOUNTPOINT$ISODIR"
menufile="$CONFIGDIR/$menufilename_load"

mount "${DEV}1" "$MOUNTPOINT"

echo 'reset menufile for loaded isos'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg" > "$menufile"


##### insert ISO entries
echo "creating $menufile ..."
for iso in $( ls "$ISOPATH/"*.iso 2> /dev/null )
do
	filename="${iso##*/}"
	NAME="$(sed -e 's/[^A-Za-z0-9_.-]/-/g' <<< "$filename")"
	NAME_HUMAN_READABLE="$(sed -e 's/.iso$//' -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )"

	vmalloc="$(du -Lm $iso | cut -f1)" # get size in MB
	vmalloc="$(($vmalloc + 1))M"
	cat >> "$menufile" <<EOF

LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  LINUX memdisk vmalloc=$vmalloc
  INITRD $ISODIR/$filename
  APPEND iso raw
EOF

	echo "  added iso entry for $NAME_HUMAN_READABLE"
done

echo "done creating $menufile"


##### unmount
sync
umount -l "${DEV}1"
