#!/bin/bash

source config
source check_preconditions.sh

echo -n "re-formatting $DEV
all data will be lost!
Type YES to continue
> "

if [[ $FORCE > 0 ]]; then
   echo "flag FORCE set, continue anyway"
else
   read ANSWER
   if [[ $ANSWER != "YES" ]]; then
      echo "aborting"
      exit 0
   fi
fi

echo
