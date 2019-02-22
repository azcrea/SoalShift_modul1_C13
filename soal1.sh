#!/bin/bash

tempat=/home/duhbuntu/sisop/prak1
if [[ ! -d "$tempat/nature"  ]]; then unzip $tempat/nature.zip -d $tempat; fi

k=0

if [[ ! -d "$tempat/nature/hasil"  ]]; then mkdir $tempat/nature/hasil; fi

for n in $tempat/nature/*.jpg;
do
 foto=$(basename $n .jpg)
 #echo $foto
 base64 --decode $n | xxd -r > $tempat/nature/hasil/$foto'hasil'.jpg
 k=$((k+1))
done

