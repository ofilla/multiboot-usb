#!/bin/bash

source config
source functions_formatting.sh
DEV
# unmounting
echo "unmounting $DEV ..."
umount -lf ${DEV}* 2> /dev/null

# convert partsize into MB
if [[ "$PARTSIZE" == *"G" ]]; then
    # GB
    SIZE=$(sed 's/G$//' <<< "$PARTSIZE")
    SIZE=$(( $SIZE * 1024 ))
elif [[ "$PARTSIZE" == *"M" ]]; then
    # MB
    SIZE=$(sed 's/M$//' <<< "$PARTSIZE")
else
    echo "E: cannot understand configuration: PARTSIZE=$PARTSIZE" >&2
    exit 3
fi


# partition disk
echo "repartitioning device ... "

echo 're-creating partition table'
gdisk $DEV > /dev/null <<EOF
o
y

w
y
EOF

create_partition "$DEV" "$SIZE" "$LABEL"

# set bootable flag to partition 1
echo 'setting flag to partiton: legacy BIOS bootable'
gdisk $DEV > /dev/null <<EOF
x
a
2

w
y
EOF

# create partitions for iso images to dd to
DD_ISOS=$(ls dd_isos)
for iso in $DD_ISOS
do
    create_partition "$DEV" $(du -m dd_isos/$iso) "${iso##*/}"
done
