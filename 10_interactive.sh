#!/bin/bash

source config

echo -n "re-formatting $DEV
all data will be lost!
Type YES to continue
> "

if [[ $FORCE ]]; then
   echo "flag FORCE set, continue anyway"
else
   read ANSWER
   if [[ $ANSWER != "YES" ]]; then
      echo "aborting"
      exit 0
   fi
fi

echo
