#!/bin/bash

tempat=$(pwd)
unzip $tempat/nature.zip

k=0

mkdir $tempat/nature/hasil

for n in $tempat/nature/*.jpg;
do
 foto=$(basename $n .jpg)
 #echo $foto
 base64 --decode $n | xxd -r > $tempat/nature/hasil/$foto'hasil'.jpg
 k=$((k+1))
done
