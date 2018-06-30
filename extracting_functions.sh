source config

CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufile="$CONFIGDIR/$menufilename"

function backup_original_config() {
    # copy original config files for isolinux
    # if files exist
    file=${file:-$1}
    
    dir=$(dirname $MOUNTPOINT$EXTRACTED_ISODIR/$file)
    bkpdir="$dir/.cfg_bkp"

    if [[ -d $bkpdir ]]; then # bkpdir exists
	# do NOT overwrite any existing backups
	return
    fi

    mkdir $bkpdir
    for cfgfile in $dir/*.cfg
    do
    	cp -n $cfgfile $bkpdir/$(basename $cfgfile).bkp
    done
}

function load_isolinux_config() {
    ROOTDIR=${ROOTDIR:-$1}
    file=${file:-$2}
    
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
    f=$1
    for s in ui path default label kernel append include localboot 'menu begin' 'menu end' 'menu title' 'menu hide' menu 'text help' endtext
    do
    	sed -i "s/^$s /${s^^} /g" $f
    	sed -i "s/ $s / ${s^^} /g" $f
    done
}

function fix_global_paths() {
    f=$1
    for s in ' ' '\t' '='
    do
	sed -i "s!$s/!$s$ROOTDIR/!g" $f
    done
}

function fix_local_paths_for_include() {
    f=$1
    relative_cfgpath=$(sed "s!^$ROOTDIR!!g" <<< "/boot/$CFGPATH")

    if [[ -n $relative_cfgpath ]]
    then
	# relative cfgpath is not empty
	sed -i "s!INCLUDE !INCLUDE $ROOTDIR$relative_cfgpath/!g" $f
	sed -i "s!UI !UI $ROOTDIR$relative_cfgpath/!g" $f
	sed -i "s!PATH !PATH $ROOTDIR$relative_cfgpath!g" $f
	sed -i "s!gfxboot !gfxboot $ROOTDIR$relative_cfgpath/!g" $f
    fi
}

function reset_config_files() {
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
