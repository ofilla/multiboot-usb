#!/bin/bash

source config
source check_preconditions.sh

CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
ISOPATH="$MOUNTPOINT$ISODIR"
menufile="$CONFIGDIR/$menufilename_chain"

mount ${DEV}1 $MOUNTPOINT

echo 'reset menufile for loaded isos'
echo -e "INCLUDE $INCLUDEDIR/stdmenu.cfg" > $menufile

partnumber=2

for iso in $(ls $dd_isodir)
do
    filename="${iso##*/}"
    NAME=$(sed -e 's/[^A-Za-z0-9_.-]/-/g' <<< "$filename")
    NAME_HUMAN_READABLE=$(sed -e 's/.iso$//' -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF

LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  COM32 chain
  APPEND hd0,$partnumber
EOF
done

sync
umount ${DEV}1
