#!/bin/bash

name=$(echo "$1" | cut -d':' -f1)


low=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
hig=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ

rot=$((26-${name[0]}))

cat "$1" | tr "${low:0:26}" "${low:rot:26}" | tr "${hig:0:26}" "${hig:rot:26}"  > "$1-dec"
