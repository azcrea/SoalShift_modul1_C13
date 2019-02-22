#!/bin/bash

date=$(date "+%H")
loc=/home/duhbuntu/sisop/prak1
file=$(date "+%H:%M %d-%B-%Y")

low=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
hig=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ

rot=$date

cat /var/log/syslog | tr "${low:0:26}" "${low:rot:26}" | tr "${hig:0:26}" "${hig:rot:26}"  > "$loc/$file"
