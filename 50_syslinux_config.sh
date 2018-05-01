#!/bin/bash

CONFIGDIR="$MOUNTPOINT/boot/syslinux/config"
INCLUDEDIR="/boot/syslinux/config"

function use_isolinux_config()
{
    DIR=$1
    NAME=$(basename $DIR)
    NAME_HUMAN_READABLE=$( echo $NAME | sed -e 's/[^ _-]*/\u&/g' -e 's/[_-]/ /g' )
    cfgfile="$CONFIGDIR/$NAME.cfg"

    echo "INCLUDE $INCLUDEDIR/stdmenu.cfg" > $cfgfile

    # default config
    if [[ -f "$DIR/txt.cfg" ]]; then
	echo "  menu configuration found: txt.cfg"
    else
	# nesseccary
	echo "  file 'txt.cfg' does not exist!" >& 2
	echo "  this file is neccessary for configuration!" >& 2
	exit 3
    fi

    echo "MENU BEGIN $NAME" >> $cfgfile
    echo "#todo: isolinux_menu - txt.cfg: set CWD / right paths" | tee -a $cfgfile
    echo "  MENU LABEL ^$NAME_HUMAN_READABLE" >> $cfgfile
    echo "  INCLUDE $INCLUDEDIR/stdmenu.cfg" >> $cfgfile
    
    sed -e 's/^/  &/g' -e 's/\t/  /g' $DIR/txt.cfg >> $cfgfile

    echo "  LABEL MAINMENU" >> $cfgfile
    echo "    MENU LABEL ^Back" >> $cfgfile
    echo "    MENU EXIT" >> $cfgfile
    echo "MENU END" >> $cfgfile

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
