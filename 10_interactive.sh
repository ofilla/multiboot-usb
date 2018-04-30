#!/bin/bash

echo -n "re-formatting $DEV
all data will be lost!
Type YES to continue
> "

if [[ "${ARGV[@]}" = *"--force"* ]]; then
   # the argument '--force' is set in ARGV
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
