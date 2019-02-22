#!/bin/bash

tempat=$(pwd)
unzip $tempat/nature.zip

k=0

if [[ ! -d "$tempat/nature/hasil"  ]]; then mkdir $tempat/nature/hasil; fi

for n in $tempat/nature/*.jpg;
do
 foto=$(basename $n .jpg)
 #echo $foto
 base64 --decode $n | xxd -r > $tempat/nature/hasil/$foto'hasil'.jpg
 k=$((k+1))
done
