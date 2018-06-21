#!/bin/bash

INCLUDEDIR="/boot/syslinux/config"
CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"

ISODIR='/boot/iso'
ISOPATH="$MOUNTPOINT$ISODIR"

menufilename="load_submenus.cfg"
menufile="$CONFIGDIR/load_submenus.cfg"

##### mount
# mount ${DEV}1 $MOUNTPOINT



##### reset menufile
cat <<EOF > $MOUNTPOINT/boot/syslinux/syslinux.cfg
PATH /boot/syslinux/modules/bios
UI vesamenu.c32

MENU TITLE Multiboot-USB

INCLUDE $INCLUDEDIR/stdmenu.cfg
INCLUDE $INCLUDEDIR/$menufilename
INCLUDE $INCLUDEDIR/powermenu.cfg
EOF

echo 'reset menufile'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg\n" > $menufile



##### insert ISO entries
echo "creating $menufile ..."
for iso in $( ls $ISOPATH/*.iso $ISOPATH/*.ISO 2> /dev/null )
do
    filename="${iso##*/}"
    NAME=$(sed -e 's/[^A-Za-z0-9_.-]/-/g' <<< "$filename")
    NAME_HUMAN_READABLE=$(sed -e 's/.iso$//' -e 's/-/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF
LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  LINUX memdisk
  INITRD $ISODIR/$filename
  APPEND iso

EOF

    echo "  added iso entry for $NAME_HUMAN_READABLE"
done
echo "done creating $menufile"



##### unmount
sync
#umount -l ${DEV}1
