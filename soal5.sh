#!/bin/bash

loc=/home/duhbuntu
if [[ ! -d "$loc/modul1"  ]]; then mkdir $loc/modul1; fi
awk '/[Cc][Rr][Oo][Nn]/,!/[Ss][Uu][Dd][Oo]/' /var/log/syslog | awk 'NF < 13' >> $loc/modul1/nomor5.log
