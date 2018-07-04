#!/bin/bash

source config
source functions_formatting.sh

# unmounting
echo "unmounting $DEV ..."
umount -lf ${DEV}* 2> /dev/null

# convert partsize into MB
if [[ "$PARTSIZE" == *"G" ]]; then
    # GB
    SIZE=$(sed 's/G$//' <<< "$PARTSIZE")
    SIZE=$(bc <<< "$SIZE * 1024" | cut -d. -f1)
elif [[ "$PARTSIZE" == *"M" ]]; then
    # MB
    SIZE=$(sed 's/M$//' <<< "$PARTSIZE")
else
    echo "E: cannot understand configuration: PARTSIZE=$PARTSIZE" >&2
    exit 3
fi


# partition disk
echo "repartitioning device ... "
partnumber=1

echo 're-creating partition table'
gdisk $DEV > /dev/null <<EOF
o
y

w
y
EOF

create_partition "$DEV" "$free_mb" "$SIZE" "$partnumber" "$LABEL"

DD_ISOS=$(ls dd_isos)
for iso in $DD_ISOS
do
    break
done


# set bootable flag to partition 1
gdisk $DEV <<EOF
x
a
1
2

w
y
EOF

echo
