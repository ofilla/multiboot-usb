#!/bin/bash

source config
source check_preconditions.sh
source functions_formatting.sh

partnumber=2

for iso in $(ls $dd_isodir)
do
    echo -n "copying $iso via dd ... "
    dd if=$dd_isodir/$iso of=$DEV$partnumber bs=1M > /dev/null || abort "dd failed" 4
    sync
    echo done
done
