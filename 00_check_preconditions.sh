#!/bin/bash

export DEV="${ARGV[0]}"

if [[ "$DEV" == "" ]]; then
   echo "no destination device"
   exit 1
elif [[ $UID != 0 ]]; then
   echo "no root"
   exit 2
fi
