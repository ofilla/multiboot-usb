#!/bin/bash

if [[ -z "$ARGV" ]]; then
    # if ARGV is unset: set to arguments
    ARGV=( $@ )
fi

source config
export ARGV

for file in $(ls ??_*.sh); do
    source $file
done

chmod -R o+r $MOUNTPOINT/*
find $MOUNTPOINT -type d | xargs chmod o+x

echo "all done"
