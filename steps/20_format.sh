# unmounting
echo "unmounting $DEV ..."
# unmount only mounted partitions
for d in $(mount | grep "^$DEV" | cut -d' ' -f1)
do
	umount -lf $d || exit $?
done


echo "repartitioning device ... "

echo 'create fresh partition table'
sgdisk $DEV --zap-all > /dev/null
dd if=/dev/zero of=$DEV bs=1K count=128 oflag=sync conv=fsync status=none

echo 'create data partition'
create_partition "$DEV" "$DATA_PARTSIZE" "$DATA_LABEL"
mkfs.vfat -F32 -n "$DATA_LABEL" ${DEV}1 > /dev/null

echo 'create partitions for hybrid bios/efi grub'
create_partition "$DEV" "1M" "BIOS_boot"
create_partition "$DEV" "50M" "EFI"
create_partition "$DEV" "$GRUB_PARTSIZE" "$GRUB_LABEL"

# flag 2: bios bootable
# flag 63: no automount
sgdisk $DEV \
	-A 2:set:2 -A 2:set:63 -t 2:ef02 \
	-A 3:set:2 -A 3:set:63 -t 3:ef00 \
	-t 4:0700 \
	> /dev/null	

echo 'create hybrid MBR'
sgdisk $DEV -h 2 3 4 > /dev/null
sudo sfdisk -Y dos -A $DEV 4 > /dev/null

# create partitions for iso images to dd to
if [[ -d $dd_isodir ]]
then
	for iso in $dd_isodir/*
	do
		name="${iso##*/}"
		name="${name%.iso}"
		size=$(du -h "$iso")
		create_partition $DEV $size "$name"
	done
fi
