# unmounting
echo "unmounting $DEV ..."
umount -lf "${DEV}"* 2> /dev/null


echo "repartitioning device ... "

echo 're-creating partition table'
sgdisk $DEV --zap-all > /dev/null

if [[ "$GRUB_PARTITION" == "1" ]]; then
	create_partition "$DEV" "$GRUB_PARTSIZE" "$GRUB_LABEL"
	echo "creating hybrid GPT/MBR ..."
	sgdisk $DEV -h 1 > /dev/null
elif [[ "$GRUB_PARTITION" == "2" ]]; then
	create_partition "$DEV" "$DATA_PARTSIZE" "$DATA_LABEL"
	create_partition "$DEV" "$GRUB_PARTSIZE" "$GRUB_LABEL"
	echo "creating hybrid GPT/MBR ..."
	sgdisk $DEV -h 1,2 > /dev/null
else
	abort "E: GRUB_PARTITION=$GRUB_PARTITION not supported" 3
fi

echo "setting flag to partiton $GRUB_PARTITION: legacy BIOS bootable"
# flag 2: bios bootable
# flag 63: no automount
sgdisk $DEV -A $GRUB_PARTITION:set:2 \
	 -A $GRUB_PARTITION:set:63 \
	 -t $GRUB_PARTITION:ef02 \
	 > /dev/null


# create partitions for iso images to dd to
for iso in $dd_isodir/*
do
	name="${iso##*/}"
	name="${name%.iso}"
	create_partition $DEV $size "$name"
done
