#!/bin/bash

if [[ -z "$ARGV" ]]; then
    # if ARGV is unset: set to arguments
    ARGV=( $@ )
fi

source config
export ARGV

for file in $(ls ??_*.sh); do
    echo "============ start: $file"
    source $file
    echo "============ finished: $file"
done

mount ${DEV}1 $MOUNTPOINT
chmod -R o+r $MOUNTPOINT/*
find $MOUNTPOINT -type d | xargs chmod o+x
umount $MOUNTPOINT

echo "all done"
