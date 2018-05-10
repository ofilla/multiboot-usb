
#!/bin/bash

INCLUDEDIR="/boot/syslinux/config"
CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufilename="load_submenus.cfg"
menufile="$CONFIGDIR/load_submenus.cfg"

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

function load_isolinux_config() {
    NAME=$(basename "$ROOTDIR")
    NAME_HUMAN_READABLE=$(sed -e 's/[_-]/ /g' -e 's/[^ ]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF
LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  CONFIG /boot/$file
  APPEND $ROOTDIR

EOF

    export CFGPATH=$(dirname $file)
    export rootdir=$(dirname $CFGPATH | sed "s!$MOUNTPOINT!!")
    
    for cfgfile in $MOUNTPOINT/boot/$CFGPATH/*.cfg
    do
	manipulate_config_file $cfgfile
    done
}

function manipulate_config_file() {
    f=$1
    # use backup of original cfg file as source
    backed_up="$(dirname $f)/.cfg_bkp/$(basename $f).bkp"
    cp -f $backed_up $f
    
    write_keywords_uppercase $f
    fix_global_paths $f
    fix_local_paths_for_include $f
}

function write_keywords_uppercase() {
    for s in default label kernel append include localboot 'menu begin' 'menu end' 'menu title' menu 'text help' endtext
    do
    	sed -i "s/^$s /${s^^} /g" $f
    	sed -i "s/ $s / ${s^^} /g" $f
    done
}

function fix_global_paths() {
    for s in ' ' '\t' '='
    do
	sed -i "s!$s/!$s$ROOTDIR/!g" $f
    done
}

function fix_local_paths_for_include() {
    relative_cfgpath=$(sed "s!^$ROOTDIR!!g" <<< "/boot/$CFGPATH")

    if [[ -n $relative_cfgpath ]]
    then
	# relative cfgpath is not empty
	sed -i "s!INCLUDE !INCLUDE $relative_cfgpath/!g" $f
    fi
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




mount ${DEV}1 $MOUNTPOINT

reset_menufile

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

sync
umount -l ${DEV}1
