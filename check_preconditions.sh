#!/bin/bash

source config

if [[ "$DEV" == "" ]]; then
   echo "E: no destination device set"
   exit 1
elif [[ $UID != 0 ]]; then
   echo "E: no root permissions"
   exit 2
fi
