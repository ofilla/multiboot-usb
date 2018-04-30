#!/bin/bash

DEV="$1"
ARGV=$@
export DEV
export ARGV

for file in $(ls ??_*.sh); do
    source $file
done
