#!/bin/bash

loc=$(pwd)
res=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

randompassword(){
res=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
until [[ "$res" =~ [a-z]  &&  "$res" =~ [A-Z]  && "$res" =~ [0-9] ]]
do
  res=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
done

}

i=1

randompassword

while true;
do
 if [ -f "$loc/password$i.txt" ]
  then
   pass=$(awk '{print $1}' password$i.txt)
   while [ "$pass" == "$res" ]
   do
    randompassword
    #echo "ada"
   done
   i=$((i+1))
 else
  echo "$res" > password$i.txt
  #echo "$res"
  exit
 fi
done
