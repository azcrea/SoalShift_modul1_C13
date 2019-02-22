#!/bin/bash

a=$(awk 'BEGIN {FS = ",";terbanyak=0;} /2012/ {a[$1]+=$10} END{negara=0;for(b in a){if(a[b] > terbanyak){negara=b;terbanyak=a[b];}}print negara;}' WA_Sales_Products_2012-14.csv)
echo "Negara terbanyak :"
echo "$a"
echo " "

b=$(awk -v negara="$a" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $7 == 2012 ) {a[$4]+=$10} END{for(b in a){print b,a[b]}}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}')
echo "Production Line terbanyak :"
echo "$b"
echo " "

SAVEIFS=$IFS
IFS=$'\n'
produk=($b)
IFS=$SAVEIFS

declare temp=()

for (( i=0; i<${#produk[@]}; i++ ))
do
    temp[$i]="${produk[$i]}"
done

echo "${produk[0]} :"
awk -v negara="$a" -v p1="${temp[0]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
echo ""
echo "${produk[1]} :"
awk -v negara="$a" -v p1="${temp[1]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
echo ""
echo "${produk[2]} :"
awk -v negara="$a" -v p1="${temp[2]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
echo ""
echo "Top 3 Produk: "
awk -v negara="$a" -v p1="${temp[0]}" -v p2="${temp[1]}" -v p3="${temp[2]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) || ($1 == negara && $4 == p2 && $7 == 2012) || ($1 == negara && $4 == p3 && $7 == 2012)  {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv  | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'

