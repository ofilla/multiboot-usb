#!/bin/bash

####### config #######
INCLUDEDIR="/boot/syslinux/config"
ISODIR='/boot/iso'
menufilename="load_isos.cfg"
####### config #######

CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
ISOPATH="$MOUNTPOINT$ISODIR"
menufile="$CONFIGDIR/$menufilename"

##### mount
mount ${DEV}1 $MOUNTPOINT



##### reset menufile
cat <<EOF > $MOUNTPOINT/boot/syslinux/syslinux.cfg
PATH /boot/syslinux/modules/bios
UI vesamenu.c32

MENU TITLE Multiboot-USB

INCLUDE $INCLUDEDIR/stdmenu.cfg
INCLUDE $INCLUDEDIR/powermenu.cfg
INCLUDE $INCLUDEDIR/$menufilename
EOF

echo 'reset menufile'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg" > $menufile



##### insert ISO entries
echo "creating $menufile ..."
for iso in $( ls $ISOPATH/*.iso $ISOPATH/*.ISO 2> /dev/null )
do
    filename="${iso##*/}"
    NAME=$(sed -e 's/[^A-Za-z0-9_.-]/-/g' <<< "$filename")
    NAME_HUMAN_READABLE=$(sed -e 's/.iso$//' -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

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
umount -l ${DEV}1
