#!/bin/bash

echo -n "re-formatting $DEV
all data will be lost!
Type YES to continue
> "

if [[ "$2" == "--force" ]]; then
   echo
   echo "flag --force set, continue anyway"
else
   read ANSWER
   if [[ $ANSWER != "YES" ]]; then
      echo "aborting"
      exit 0
   fi
fi

echo
