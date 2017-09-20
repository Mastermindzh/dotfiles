#!/bin/bash

temp=$(sensors | # execute sensors
grep -w "Core 0:" | # grep for the first core
sed 's/([^)]*)//g' | # filter
tr -s " " | # remove whitespace
sed -e 's/Core 0\(.*\):/\1/' | #  get value between Core 0 and :
cut -c 3- | rev | cut -c 7- | rev #remove clutter
)

# echo out the result
echo $temp°C