#!/bin/bash

source config

if [[ "$DEV" == "" ]]; then
   echo "no destination device"
   exit 1
elif [[ $UID != 0 ]]; then
   echo "no root"
   exit 2
fi
