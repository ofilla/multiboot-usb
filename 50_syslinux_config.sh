#!/bin/bash

INCLUDEDIR="/boot/syslinux/config"
CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufilename="load_submenus.cfg"
menufile="$CONFIGDIR/load_submenus.cfg"

function use_isolinux_config()
{
    DIR=$1
    NAME=$(basename $DIR)

    # default config
    if [[ -f "$DIR/txt.cfg" ]]; then
	echo "  menu configuration found: txt.cfg"
    else
 	# nesseccary
	echo "  file 'txt.cfg' does not exist!" >& 2
	echo "  this file is neccessary for configuration!" >& 2
	exit 3
    fi

    NAME_HUMAN_READABLE=$( echo $NAME | sed -e 's/[^ _-]*/\u&/g' -e 's/[_-]/ /g' )
    echo '    create entry in menufile'
    cat <<EOF >> $menufile
INCLUDE $INCLUDEDIR/stdmenu.cfg
MENU BEGIN $NAME
#todo: isolinux_menu - txt.cfg: set CWD / right paths
  MENU LABEL ^$NAME_HUMAN_READABLE
  INCLUDE $INCLUDEDIR/stdmenu.cfg
  INCLUDE $INCLUDEDIR/${NAME}.cfg
  LABEL mainmenu
    MENU LABEL ^Back
    MENU EXIT
MENU END
EOF
    
    echo '    create cfgfile'
    cfgfile="$CONFIGDIR/$NAME.cfg"
    echo -e "PATH /boot/${NAME}\n" > $cfgfile
    cat $DIR/txt.cfg >> $cfgfile

    

    cat <<EOF


ToDo:
  * create adv. options menu (below)
  * fix path (above, see #todo
  * create load_configs.cfg file, to load the here-created cfg file
NOT IMPLEMENTED!!!
EOF
    exit 5
    
    # advanced options
    if [[ -f "$DIR/adtxt.cfg" ]]; then
	echo "  advanced configuration found: adtxt.cfg"
    else
	echo "  no advanced configuration found: adtxt.cfg"
    fi

    
}

cat <<EOF > $MOUNTPOINT/boot/syslinux/syslinux.cfg
PATH /boot/syslinux/modules/bios /boot/syslinux/modules/efi32 /boot/syslinux/modules/efi64
UI vesamenu.c32

MENU TITLE Multiboot-USB

INCLUDE $INCLUDEDIR/stdmenu.cfg
INCLUDE $INCLUDEDIR/$menufilename
INCLUDE $INCLUDEDIR/powermenu.cfg
EOF

echo 'reset menufile'
echo -n '' > $menufile

for DIR in $(ls -d $MOUNTPOINT/boot/*/ | grep -v 'syslinux/$')
do
    filename="${DIR}isolinux.cfg"
    if [[ -e $filename ]]; then
	echo "$filename found"

	cd $DIR
	use_isolinux_config $DIR
	cd - > /dev/null
    fi
done
