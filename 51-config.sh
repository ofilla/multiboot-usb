#!/bin/bash

INCLUDEDIR="/boot/syslinux/config"
CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufilename="load_submenus.cfg"
menufile="$CONFIGDIR/load_submenus.cfg"

function load_isolinux_config() {
    ROOT=$(sed "s!^$MOUNTPOINT!!" <<< $1)
    CFGFILE=$(sed "s!^$MOUNTPOINT!!" <<< $2)
    NAME=$(basename "$ROOT")
    NAME_HUMAN_READABLE=$(sed -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF
LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  CONFIG $CFGFILE
  APPEND $ROOT

EOF

    CFGPATH=$(dirname $CFGFILE)
    sed -i 's! /! ../!g' $MOUNTPOINT$CFGPATH/*.cfg
    sed -i 's!=/!=../!g' $MOUNTPOINT$CFGPATH/*.cfg

    # for file in $CFGPATH/*.cfg
    # do
	
    # done
}

function reset_menufile() {
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
}

reset_menufile

function backup_original_config() {
    # copy original config files for isolinux
    # if files exist
    dir=$(dirname $1)
    bkpdir="$dir/.cfg_bkp"

    mkdir -p $bkpdir

    for file in $dir/*.cfg
    do
	cp -n $file $bkpdir/$(basename $file).bkp
    done
}

for ROOTDIR in $(find $MOUNTPOINT/boot/* -maxdepth 0 -type d | grep -v 'syslinux$')
do
    for file in $(find $ROOTDIR -type f -name isolinux.cfg -print)
    do
    	echo "found $(basename $file) in $(basename $ROOTDIR)"
	backup_original_config "$file"
    	load_isolinux_config "$ROOTDIR" "$file"
    done
done
