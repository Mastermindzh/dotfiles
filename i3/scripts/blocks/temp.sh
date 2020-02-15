#!/bin/bash

intelTemp=$(sensors | # execute sensors
grep -w "Core 0:" | # grep for the first core
sed 's/([^)]*)//g' | # filter
tr -s " " | # remove whitespace
sed -e 's/Core 0\(.*\):/\1/' | #  get value between Core 0 and :
cut -c 3- | rev | cut -c 7- | rev #remove clutter
)

amdTemp=$(sensors | grep -w "Tdie:" | sed 's/([^)]*)//g' | tr -s " " | cut -c 8- | rev | cut -c 6- | rev)

# echo out the result
if [ -z "$intelTemp" ]
then
      echo $amdTemp
else
      echo $intelTemp°C
fi

