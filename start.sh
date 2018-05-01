#!/bin/bash

if [[ -z "$ARGV" ]]; then
    # if ARGV is unset: set to arguments
    ARGV=( $@ )
fi

export ARGV
MOUNTPOINT=/mnt
export MOUNTPOINT

for file in $(ls ??_*.sh); do
    source $file
done

echo "all done"
