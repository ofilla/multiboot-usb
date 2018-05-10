
#!/bin/bash

INCLUDEDIR="/boot/syslinux/config"
CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufilename="load_submenus.cfg"
menufile="$CONFIGDIR/load_submenus.cfg"

function load_isolinux_config() {
    NAME=$(basename "$ROOTDIR")
    NAME_HUMAN_READABLE=$(sed -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF
LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  CONFIG $ROOTDIR/$FILENAME
  APPEND $ROOTDIR

EOF

    CFGPATH=$(dirname $file)

    for f in $MOUNTPOINT/boot/$CFGPATH/*.cfg
    do
	manipulate_config_file $f
    done
}

function manipulate_config_file() {
    sed -i 's! /! ../!g' $1
    sed -i 's!=/!=../!g' $1
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
    # VARIABLES MOUNTPOINT AND file MUST BE SET!
    
    # copy original config files for isolinux
    # if files exist
    
    dir=$(dirname $MOUNTPOINT/boot/$file)
    bkpdir="$dir/.cfg_bkp"

    mkdir -p $bkpdir

    for cfgfile in $dir/*.cfg
    do
	cp -n $cfgfile $bkpdir/$(basename $cfgfile).bkp
    done
}

for ROOTDIR in $(find $MOUNTPOINT/boot/* -maxdepth 0 -type d | grep -v 'syslinux$')
do
    FILENAME=isolinux.cfg
    export ROOTDIR=$(sed "s!^$MOUNTPOINT!!" <<< "$ROOTDIR")
    for file in $(find $MOUNTPOINT$ROOTDIR -type f -name $FILENAME -print)
    do
	export file=$(sed "s!^$MOUNTPOINT/boot/!!" <<< $file)
    	echo "found $file"

	backup_original_config
    	load_isolinux_config
    done
done
