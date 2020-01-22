echo "formatting grub partition as ext4"

mkfs.ext4 -q -F -L "$GRUB_LABEL" $GRUBDEV > /dev/null

echo "installing grub"
mount $GRUBDEV "$MOUNTPOINT" || exit 1

grub-install --compress=gz --boot-directory="$MOUNTPOINT/boot" --skip-fs-probe $DEV

umount -lf $GRUBDEV
