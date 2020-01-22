CONFIGDIR="$MOUNTPOINT$INCLUDEDIR"
menufile="$CONFIGDIR/$menufilename_extract"

function backup_original_config() {
	# copy original config files for isolinux
	# if files exist
	file="${file:-$1}"
	
	dir="$(dirname "$MOUNTPOINT$EXTRACTED_ISODIR/$file")"
	bkpdir="$dir/.cfg_bkp"

	if [[ -d "$bkpdir" ]]; then # bkpdir exists
		# do NOT overwrite any existing backups
		return
	fi

	mkdir "$bkpdir"
	for cfgfile in "$dir/"*.cfg
	do
		cp -n "$cfgfile" "$bkpdir/$(basename "$cfgfile").bkp"
	done
}

function load_isolinux_config() {
	file="$1"
	ROOTDIR="$2"
	
	NAME="$(basename "$ROOTDIR")"
	NAME_HUMAN_READABLE="$(sed -e 's/[_]/ /g' -e 's/[^. -]*/\u&/g' <<< "$NAME" )"

	cat >> "$menufile" <<EOF

LABEL $NAME
  MENU LABEL $NAME_HUMAN_READABLE
  CONFIG $EXTRACTED_ISODIR/$file
  APPEND $ROOTDIR
EOF

	export CFGPATH="$(dirname "$file")"
	export ROOTDIR

	for cfgfile in $(ls "$MOUNTPOINT$EXTRACTED_ISODIR/$CFGPATH/"*.cfg)
	do
		manipulate_config_file $cfgfile
	done
}

function manipulate_config_file() {
	f="$1"

	# use backup of original cfg file as source
	backed_up="$(dirname $f)/.cfg_bkp/$(basename "$f").bkp"
	cp -f "$backed_up" "$f"
	
	write_keywords_uppercase "$f"
	fix_paths_for_include "$f"
}

function write_keywords_uppercase() {
	f="$1"
	
	sed_cmd=""
	for s in ui path default label kernel initrd append include localboot \
		'menu begin' 'menu end' 'menu title' 'menu hide' 'menu color' \
		menu 'text help' endtext config
	do # FIXME
		sed_cmd="$sed_cmd -e 's/^$s /${s^^} /g'"
		sed_cmd="$sed_cmd -e 's/ $s / ${s^^} /g'"
		sed_cmd="$sed_cmd -e 's/\t$s /\t${s^^} /g'"
	done
	for s in 'text help' endtext
	do
		sed_cmd="$sed_cmd -e 's/^$s$/${s^^}/g'"
		sed_cmd="$sed_cmd -e 's/ $s$/ ${s^^}/g'"
		sed_cmd="$sed_cmd -e 's/\t$s$/\t${s^^}/g'"
	done

	echo "$sed_cmd" "$f" | xargs sed -i
}

function fix_paths_for_include() {
	f="$1"
	local_cfgpath="$(sed "s!^$ROOTDIR/!!g" <<< "$EXTRACTED_ISODIR/$CFGPATH")"

	sed_cmd=""
	# fix locale paths
	if [[ -n "$local_cfgpath" ]]
	then
		for param in INCLUDE UI PATH KERNEL INITRD CONFIG gfxboot 'MENU BACKGROUND'
		do
			# convert global to local path
			sed_cmd="$sed_cmd -e 's!$param /!$param /$local_cfgpath/!g'"
			sed_cmd="$sed_cmd -e 's!$param [^/]!$param $local_cfgpath/!g'"
		done
	fi
	
	# fix absolute paths
	for param in INCLUDE UI PATH KERNEL INITRD CONFIG gfxboot
	do
		# convert global to local path
		sed_cmd="$sed_cmd -e 's!$param /!$param $EXTRACTED_ISODIR/!g'"
	done

	sed_cmd="$sed_cmd -e 's!initrd=/!initrd=!g'"

	echo "$sed_cmd" "$f" | xargs sed -i
}
