#!/usr/bin/env bash

cd /boot

# check if the string "modules-load=dwc2" in config.txt exists.
if grep -q "modules-load=dwc2" config.txt; then
  echo "dwc2 is already enabled"
else
  echo "dwc2" >> config.txt
  echo "dwc2 enabled"
fi
