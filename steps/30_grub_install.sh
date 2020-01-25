echo "formatting grub partitions"
mkfs.vfat -n GRUB2EFI ${DEV}2 > /dev/null
mkfs.vfat -F 32 -n EFI ${DEV}3 > /dev/null
mkfs.ext4 -q -F -L "$GRUB_LABEL" $GRUBDEV > /dev/null

echo "installing grub"
mount $GRUBDEV "$MOUNTPOINT" || exit $?
mkdir -p "$MOUNTPOINT"/boot/efi
mount ${DEV}3 "$MOUNTPOINT"/boot/efi || exit $?

# EFI grub
grub-install \
	--target=x86_64-efi \
	--efi-directory="$MOUNTPOINT"/boot/efi \
	--boot-directory="$MOUNTPOINT"/boot \
	--removable \
	--recheck \
	$DEV
# BIOS grub
grub-install \
	--target=i386-pc \
	--boot-directory="$MOUNTPOINT"/boot \
	--recheck \
	$DEV

touch "$MOUNTPOINT/boot/grub/grub.cfg"
find "$MOUNTPOINT"/boot/efi -type f -print0 | xargs -0 fatattr +hsr -a

umount ${DEV}3 || exit $?
rmdir "$MOUNTPOINT"/boot/efi
umount $GRUBDEV || exit $?
