source config

CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufile="$CONFIGDIR/$menufilename_extract"

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
    file=$1
    ROOTDIR=$2
    
    NAME=$(basename "$ROOTDIR")
    NAME_HUMAN_READABLE=$(sed -e 's/[_]/ /g' -e 's/[^. -]*/\u&/g' <<< "$NAME" )

    cat >> $menufile <<EOF

LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  CONFIG $EXTRACTED_ISODIR/$file
  APPEND $ROOTDIR
EOF

    export CFGPATH=$(dirname $file)
    export ROOTDIR

    for cfgfile in $(ls $MOUNTPOINT$EXTRACTED_ISODIR/$CFGPATH/*.cfg)
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
    fix_paths_for_include $f
}

function write_keywords_uppercase() {
    f=$1
    for s in ui path default label kernel append include localboot \
		'menu begin' 'menu end' 'menu title' 'menu hide' 'menu color' \
		menu 'text help' endtext config
    do
    	sed -i "s/^$s /${s^^} /g" $f
    	sed -i "s/ $s / ${s^^} /g" $f
    	sed -i "s/\t$s /\t${s^^} /g" $f
    done
    for s in 'text help' endtext
    do
    	sed -i "s/^$s$/${s^^}/g" $f
    	sed -i "s/ $s$/ ${s^^}/g" $f
    	sed -i "s/\t$s$/\t${s^^}/g" $f
    done
}

function fix_paths_for_include() {
    f=$1
    local_cfgpath=$(sed "s!^$ROOTDIR/!!g" <<< "$EXTRACTED_ISODIR/$CFGPATH")

    # fix locale paths
    if [[ -n $local_cfgpath ]]
    then
    	for param in INCLUDE UI PATH KERNEL CONFIG gfxboot 'MENU BACKGROUND'
    	do
    	    # convert global to local path
    	    sed -i "s!$param !$param $local_cfgpath/!g" $f
    	done
    fi
    
    # fix absolute paths
    for param in INCLUDE UI PATH KERNEL CONFIG gfxboot
    do
	# convert global to local path
	sed -i "s!$param $local_cfgpath//!$param !g" $f
    done
    sed -i 's!initrd=/!initrd=!g' $f
}
