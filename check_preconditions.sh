#!/bin/bash

source config

if [[ "$DEV" == "" ]]; then
   echo "E: no destination device set" >&2
   exit 1
elif [[ -z "$(ls $DEV 2> /dev/null)" ]]; then
    echo "E: destination device '$DEV' is not available" >&2
    exit 1
elif [[ $UID != 0 ]]; then
   echo "E: no root permissions" >&2
   exit 2
fi
