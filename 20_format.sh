#!/bin/bash

echo "unmounting $DEV ..."
umount -lf ${DEV}* 2> /dev/null

# partition disk
BOOTUSB=10G
echo -e "repartitioning device ... 
partition 1: \t $BOOTUSB \t for BOOTUSB
partition 2: \t rest \t for persistent data
"
fdisk $DEV <<EOF
o
n
p
1

+${BOOTUSB}
a

n
p
2


w
EOF
