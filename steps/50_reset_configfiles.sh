mount "${DEV}1" "$MOUNTPOINT" || exit $?

##### reset syslinux.cfg
cat > "$MOUNTPOINT/boot/syslinux/syslinux.cfg" <<EOF
PATH /boot/syslinux/modules/bios
UI vesamenu.c32

MENU TITLE Multiboot-USB

INCLUDE $INCLUDEDIR/stdmenu.cfg
INCLUDE $INCLUDEDIR/powermenu.cfg
INCLUDE $INCLUDEDIR/$menufilename_chain
INCLUDE $INCLUDEDIR/$menufilename_load
INCLUDE $INCLUDEDIR/$menufilename_extract
EOF

umount "${DEV}1" || exit $?
