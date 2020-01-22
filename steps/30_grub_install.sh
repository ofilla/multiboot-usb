echo "formatting grub partition"

mkfs.ext4 -q -F -L "$GRUB_LABEL" "$GRUBDEV"

echo "installing grub"
mount $GRUBDEV "$MOUNTPOINT" || exit 1

grub-install --compress=gz --boot-directory="$MOUNTPOINT/boot" --skip-fs-probe $DEV

umount -lf $GRUBDEV

exit 0