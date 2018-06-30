#!/bin/bash

source config

# get partition size in MB
eval $(lsblk -Pid $DEV -o SIZE) # disksize
SIZE=$(sed -e 's/,/./' <<< "$SIZE")
if [[ "$SIZE" == *"G" ]]; then
    # GB
    SIZE=$(bc <<< "$SIZE * 1000" | cut -d. -f1)
else
    echo "$SIZE is not usable yet" >&2
    exit 3
fi

if [[ $SIZE -gt $PARTITION_SIZE ]]; then
    # use partition size if possible
    # if device is too small, use entire device
    SIZE=$PARTITION_SIZE
fi

echo "unmounting $DEV ..."
umount -lf ${DEV}* 2> /dev/null

# partition disk
echo -e "repartitioning device ... 
partition 1: \t $SIZE \t for $PARTITION_LABEL
partition 2: \t rest \t for persistent data
"
fdisk $DEV <<EOF
o
n
p
1

+${SIZE}M

a

w
EOF

echo
