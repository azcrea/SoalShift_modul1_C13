# SoalShift_modul1_C13
## Soal 1
Anda diminta tolong oleh teman anda untuk mengembalikan filenya yang telah dienkripsi oleh seseorang menggunakan bash script, file yang dimaksud adalah nature.zip. Karena terlalu mudah kalian memberikan syarat akan membuka seluruh file tersebut jika pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari jumat pada bulan Februari.
Hint: Base64, Hexdump
### Jawab:
Diketahui bahwa isi nature.zip adalah sebuah file terenkripsi yang berekstensi `.jpeg`. Ketika di buka akan muncul error karena header yang digunakan bukan merupakan header `.jpeg`. Oleh karena itu langkah awal yang harus dilakukan adalah mendekripsi Foto tersebut dengan base64 encoding. Hasil yang decode tersebut akan memberikan hexdump dari file tersebut, sehingga kita bisa mereturn hexdump tersebut ke biner aslinya dengan script `xxd` yang disediakan linux.
```bash
#!/bin/bash

tempat=/home/duhbuntu/sisop/prak1
if [[ ! -d "$tempat/nature"  ]];then unzip $tempat/nature.zip -d $tempat; fi

k=0

if [[ ! -d "$tempat/nature/hasil"  ]]; then mkdir $tempat/nature/hasil; fi

for n in $tempat/nature/*.jpg;
do
 foto=$(basename $n .jpg)
 #echo $foto
 base64 --decode $n | xxd -r > $tempat/nature/hasil/$foto'hasil'.jpg
 k=$((k+1))
done
```
+ `if [[ ! -d "$tempat/nature"  ]];then unzip $tempat/nature.zip -d $tempat; fi` untuk cek apakah terdapat nature telah diekstrak, apabila belum maka esktrak dengan `unzip`
+ `if [[ ! -d "$tempat/nature/hasil"  ]]; then mkdir $tempat/nature/hasil; fi`, kita kumpulan file yang telah di dekripsi pada folder `nature/hasil`
+ `for n in $tempat/nature/*.jpg;` untuk setiap foto pada folder tersebut,
+ `foto=$(basename $n .jpg)` ambil basename dari foto tersebut
+ `base64 --decode $n | xxd -r > $tempat/nature/hasil/$foto'hasil'.jpg`, lalu decode dengan `base64 --decode $n`, dan reverse dengan `xxd -r` , lalu simpan pada `/home/duhbuntu/sisop/prak1/nature/hasil/$foto'hasil'.jpg`
Setelah itu masukkan pada crontab dengan `crontab -e` lalu isi dengan 
`14 14 14 2 5 /bin/bash /home/duhbuntu/sisop/prak1/soal1.sh`

## Soal 2
Anda merupakan pegawai magang pada sebuah perusahaan retail, dan anda diminta untuk memberikan laporan berdasarkan file WA_Sales_Products_2012-14.csv. Laporan yang diminta berupa:
   * Tentukan negara dengan penjualan(quantity) terbanyak pada tahun 2012.
   * Tentukan tiga product line yang memberikan penjualan(quantity) terbanyak pada soal poin a.
   * Tentukan tiga product yang memberikan penjualan(quantity) terbanyak berdasarkan tiga product line yang didapatkan pada soal poin b.
### Jawab:
   * Untuk mendapatkan kota terbanyak quantity nya, sehingga kita perlu mencari setiap pendapatan pada tahun 2012 per negaranya
     ```bash
     a=$(awk 'BEGIN {FS = ",";terbanyak=0;} 
     /2012/ {a[$1]+=$10} 
     END{negara=0;for(b in a){if(a[b] > terbanyak)
     {negara=b;terbanyak=a[b];}}print negara;}' WA_Sales_Products_2012-14.csv)
     echo "Negara terbanyak :"
     echo "$a"
     echo " "
     ```
     + `FS = ","` berarti field separator/delimiter dari setiap record adalah '`,`' (koma)
     + `terbanyak=0`, merupakan variabel untuk menyimpan `quantity` terbanyak
     + `/2012/`, berarti mengambil seluruh data yang berada pada tahun 2012
     + `a[$1]+=$10`, berarti menjumlahkan seluruh quantity, `$10`, berdasarkan negaranya, atau dalam hal ini dalam array a dengan indeks `a[$1]`
     + `for(b in a){if(a[b] > terbanyak){negara=b;terbanyak=a[b];}}`, berarti akan mengecek setiap indeks array a, yakni array map, `a["United States"]` apakah ia merupakan negara dengan **quantity** terbanyak dengan `if(a[b] > terbanyak) {negara=b;terbanyak=a[b];}` lalu mencetak negara tersebut dan menyimpannya di variabel a
     
   * Untuk mendapatkan tiga production line terbanyak, maka kita bisa menggunakan cara yang sama, namun karena kita membutuh kan tiga production line terbanyak, kita bisa memanfaatkan command `sort` yang berfungsi untuk menyortir baik ASC maupun DESC berdasarkan kolom tertentu (defaultnya adalah kolom pertama), dan juga `head` yang berfungsi untuk mengambil data teratas dari suatu file. Setelah itu kita simpan di variabel bash `$b`
     ```bash 
     b=$(awk -v negara="$a" 'BEGIN {FS = ",";OFS=FS} 
     ($1 == negara && $7 == 2012 ) {a[$4]+=$10} 
     END{for(b in a)
      {
       print b,a[b]
      }}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}')
     echo "Production Line terbanyak :"
     echo "$b"
     echo " "
     ```
     + `awk -v negara="$a"`, berarti awk akan menginterpretasi variabel `$a` pada bash menjadi variabel `negara` pada awk.
     + `OFS=FS`, berarti output dari awk tersebut akan dipisahkan oleh delimiter yang sama seperti `FS` yakni `','` (koma)
     + `($1 == negara && $7 == 2012 )`, berarti awk akan mengambil seluruh negara, kolom `$1`, yang merupakan hasil dari soal a, dan mengambil seluruh data yang memiliki nilai 2012 pada kolom `$7` yakni tahunnya
     + `a[$4]+=$10`, berarti menjumlahkan seluruh quantity, `$10`, berdasarkan product line, atau dalam hal ini dalam array a dengan indeks `a[$4]`
     + `sort -nrk2 -t,`, berarti akan menyortir seluruh data tersebut, `-nrk2` berarti akan disortir secara DESC berdasarkan kolom ke dua, `-t,` dengan field yang dipisahkan oleh koma
     + `head -n3`, berarti akan mengambil tiga data pertama
     
   * Untuk mendapatkan nomer 3, langkah yang dibutuh kan sama, namun dari seluruh data pada variabel b tadi, kita perlu memisahnya dan memindahkannya pada array. Karena masing-masing string dipisahkan oleh `\n`, maka dari itu kita bisa mengganti `IFS` yang merupakan variabel bash yang merupakan field separator array menjadi `\n`, lalu menyimpan seluruhnya di sebuah array `temp`
     ```bash
     SAVEIFS=$IFS
     IFS=$'\n'
     produk=($b)
     IFS=$SAVEIFS
     
     declare temp=()
     
     for (( i=0; i<${#produk[@]}; i++ ))
     do
      temp[$i]="${produk[$i]}"
     done
     ```
     + `IFS=$'\n'` Mengganti IFS menjadi endline
     + `temp=()` Merupakan inisialisasi array `temp`
     + `temp[$i]="${produksi[$i]}"` Memasukkan masing-masing production line ke array temp
     
     **Untuk mendapatkan tiga produk teratas dari masing-masing production line**
     kita bisa mendapatkan masing-masing dengan cara yang sama seperti mendapatkan tiga produk teratas dari negara, yakni
     + `a[$6]+=$10`, berarti menjumlahkan seluruh quantity, `$10`, berdasarkan product, atau dalam hal ini dalam array a dengan indeks `a[$6]`
     + `sort -nrk2 -t,`, berarti akan menyortir seluruh data tersebut, `-nrk2` berarti akan disortir secara DESC berdasarkan kolom ke dua, `-t,` dengan field yang dipisahkan oleh koma
     + `head -n3`, berarti akan mengambil tiga data pertama
     
     ```bash
     echo "${produk[0]} :"
     awk -v negara="$a" -v p1="${temp[0]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
     echo ""
     echo "${produk[1]} :"
     awk -v negara="$a" -v p1="${temp[1]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
     echo ""
     echo "${produk[2]} :"
     awk -v negara="$a" -v p1="${temp[2]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara && $4 == p1 && $7 == 2012) {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
     echo ""
     ```
     **Untuk mendapatkan tiga produk teratas dari seluruh production line**
     ```bash
     echo "Top 3 Produk: "
     awk -v negara="$a" -v p1="${temp[0]}" -v p2="${temp[1]}" -v p3="${temp[2]}" 'BEGIN {FS = ",";OFS=FS} ($1 == negara &&$4 == p1 && $7 == 2012) || ($1 == negara && $4 == p2 && $7 == 2012) || ($1 == negara && $4 == p3 && $7 == 2012)  {a[$6]+=$10} END{for(b in a) print b,a[b]}' WA_Sales_Products_2012-14.csv  | sort -nrk2 -t, | head -n3 | awk 'BEGIN{FS=","} {print $1}'
     ```
     
## Soal 3
Buatlah sebuah script bash yang dapat menghasilkan password secara acak sebanyak 12 karakter yang terdapat huruf besar, huruf kecil, dan angka. Password acak tersebut disimpan pada file berekstensi .txt dengan ketentuan pemberian nama sebagai berikut:
   * Jika tidak ditemukan file password1.txt maka password acak tersebut disimpan pada file bernama password1.txt
   * Jika file password1.txt sudah ada maka password acak baru akan disimpan pada file bernama password2.txt dan begitu seterusnya.
   * Urutan nama file tidak boleh ada yang terlewatkan meski filenya dihapus.
   * Password yang dihasilkan tidak boleh sama.
### Jawab:
Untuk mendapat kan random, kita bisa mengambil sebuah random generator yang disediakan oleh linux pada `/dev/urandom`. Dari random tersebut tentu kita harus mengambil hanya huruf kecil, huruf besar, dan angkanya saja, oleh karena itu kita bisa menggunakan fungsi `tr -dc 'a-zA-Z0-9'` yang berarti kita hanya mengambil lowercase a-z, uppercase A-Z, dan number dari random tersebut karena `tr -dc` berarti menghapus komplemen dari pola `'a-zA-Z0-9`, lalu kita bisa mengambil hanya 12 bagian pertamanya saja dengan `fold -w 12'` yang berarti mengambil hanya 12 bagian hurufnya.
```bash
#!/bin/bash

loc=$(pwd)

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
   i=$((i+1))echo "$res" > password$i.txt
  #echo "$res"
  exit
 else
  echo "$res" > password$i.txt
  #echo "$res"
  exit
 fi
done
```
Karena terkadang `fold` mengambil 12 bagian pertama dari random generator tersebut terkadang tidak termasuk huruf kecil dan atau huruf besar serta angka, maka kita ulang ketika tidak memenuhi aturan dengan fungsi `randompassword()`
+ Fungsi `randompassword()` berfungsi untuk mengenerate password selama belum memenuhi kondisi **a-zA-Z0-9**
+ `if [ -f "$loc/password$i.txt" ]` berfungsi untuk mengecek apakah ada file password-n.txt, apabila ada maka
+ `awk '{print $1}' password$i.txt` kita ambil isi dari file password yang ada tersebut
+  `while [ "$pass" == "$res" ] do randompassword` lalu kita generate password baru apabila password baru tersebut sama dengan password yang sudah ada tersebut
+ `echo "$res" > password$i.txt exit` apabila sudah tidak sama dengan password lain dan pada password-n.txt yang belum tersedia, maka simpan dan exit dari script tersebut


## Soal 4
Lakukan backup file syslog setiap jam dengan format nama file “jam:menit tanggal-bulan-tahun”. Isi dari file backup terenkripsi dengan konversi huruf (string manipulation) yang disesuaikan dengan jam dilakukannya backup misalkan sebagai berikut:
   * Huruf b adalah alfabet kedua, sedangkan saat ini waktu menunjukkan pukul 12, sehingga huruf b diganti dengan huruf alfabet yang memiliki urutan ke 12+2 = 14.
   * Hasilnya huruf b menjadi huruf n karena huruf n adalah huruf ke empat belas, dan seterusnya.
   * setelah huruf z akan kembali ke huruf a
   * Backup file syslog setiap jam.
   * dan buatkan juga bash script untuk dekripsinya.
### Jawab:
### Enkripsi:
Untuk meng-enkripsi back up dari **/var/log/syslog**, kita perlu waktu ketika script tersebut dijalankan. Untuk itu kita bisa menggunakan command `date "+%H"` dan menyimpannya pada sebuah variable untuk diolah pada scriptnya. Dari masalah ini, kita bisa menggunakan command `tr` untuk mentranslate sebuah set pattern dari suatu karakter menjadi karakter lain,
command `tr [SET1] [SET2]` berarti string yang mengandung **SET1** akan di translate / dirubah ke **SET2**, berikut script yang bisa digunakan untuk enkripsi
```bash
#!/bin/bash

date=$(date "+%H")
loc=/home/duhbuntu/sisop/prak1
file=$(date "+%H:%M %d-%B-%Y")

low=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
hig=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ

rot=$date

cat /var/log/syslog | tr "${low:0:26}" "${low:rot:26}" | tr "${hig:0:26}" "${hig:rot:26}"  > "$loc/$file"
```
+ `low` berarti sebuah set karakter alfabet lowercase asli yakni **a-z**
+ `high` berarti sebuah set karakter alfabet uppercase asli yakni **A-Z**
+ `rot` berarti rotasi/geser dari alfabet, dalam hal ini berupa jam
+ `"${low:0:26}"` berarti seluruh karakter dari **$low** mulai dari indeks ke 0 hingga 26, yang berarti kumpulan SET alfabet yang urut
+ `"${low:rot:26}"` berarti seluruh karakter dari **$low** mulai dari indeks ke **$rot** hingga **$rot+26**, yang berarti kumpulan set karakter alfabet yang digeser sebesar **$rot**
+ `tr "${low:0:26}" "${low:rot:26}"` berarti setiap karakter dengan SET karakter pola **${low:0:26}** akan diganti ke SET karakter pola **${low:$rot:26}**. Semisal sekarang menunjukkan pukul 7, maka SET 1, yakni **[a-z]** akan dirubah ke SET 2 yakni **[h-za-g]**, jadi **abcdefghijklmnopqrstuvwxyz** **(low indeks 0 hingga 26+0)** akan dirubah ke **hijklmnopqrstuvwxyzabcdefg** **(low indeks ke 7 hingga 26+7)**
+ `> $loc/$file` berarti kita akan memasukkan backup tersebut ke file pada `/home/duhbuntu/sisop/prak1/[nama-file]`
Karena script tersebut dijalankan setiap jam, maka `crontab -e` yang digunakan adalah
`@hourly /bin/bash /home/duhbuntu/sisop/prak1/soal4.sh` yang berarti dijalankan perjam


### Dekripsi
Untuk dekripsi dari file kita bisa mengikuti cara yang sama dengan enkripsi, hanya saja rotasinya kita rubah menjadi **26-jam**, sehingga merotasi ke sisa dari kunci enkripsi tersebut.
```bash
#!/bin/bash

name=$(echo "$1" | cut -d':' -f1)


low=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
hig=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ

rot=$((26-${name[0]}))

cat "$1" | tr "${low:0:26}" "${low:rot:26}" | tr "${hig:0:26}" "${hig:rot:26}"  > "$1-dec"
```
+ `echo "$1" | cut -d':' -f1` berarti kita hanya mengambil jam dari nama argumen file yang kita dekripsi


## Soal 5
Buatlah sebuah script bash untuk menyimpan record dalam syslog yang memenuhi kriteria berikut:
   * Tidak mengandung string “sudo”, tetapi mengandung string “cron”, serta buatlah pencarian stringnya tidak bersifat case sensitive, sehingga huruf kapital atau tidak, tidak menjadi masalah.
   * Jumlah field (number of field) pada baris tersebut berjumlah kurang dari 13.
   * Masukkan record tadi ke dalam file logs yang berada pada direktori /home/[user]/modul1.
   * Jalankan script tadi setiap 6 menit dari menit ke 2 hingga 30, contoh 13:02, 13:08, 13:14, dst.
### Jawab:
Dari soal diatas, maka kita perlu memparsing seluruh text yang memiliki pola `'cron'` dan `'sudo'`, lalu kita perlu mengeksklusi seluruh string yang memiliki pola `'sudo'` agar tidak ada string yang memiliki pola `'sudo'` pada log tersebut. 
```bash
#!/bin/bash

loc=/home/duhbuntu
if [[ ! -d "$loc/modul1"  ]]; then mkdir $loc/modul1; fi
awk '/[Cc][Rr][Oo][Nn]/,!/[Ss][Uu][Dd][Oo]/' /var/log/syslog | awk 'NF < 13' >> $loc/modul1/nomor5.log
```
+ `if [[ ! -d "$loc/modul1"  ]]; then mkdir $loc/modul1; fi` berarti apabila belum ada direktori `/home/duhbuntu/modul1`, maka akan membuat file `home/duhbuntu/modul1`
+ `/[Cc][Rr][Oo][Nn]/` berarti seluruh string yang memiliki pola `cron` baik uppercase maupun lowercase akan diambil oleh awk
+ `!/[Ss][Uu][Dd][Oo]/` berarti seluruh string yang memiliki pola `sudo` baik uppercase maupun lowercase akan diekslusi oleh awk 
+ `NF < 13` berarti akan mengambil hingga field ke 12
+ `>> $loc/modul1/nomor5.log` berarti hasildari awk tersebut akan write di file `/home/duhbuntu/modul1/nomor5.log`
+ Lalu pada `crontab -e` kita tambahkan `2-30/6 * * * * /bin/bash /home/duhbuntu/sisop/prak1/soal5.sh`
