# SoalShift_modul1_C13
## Soal 1
Anda diminta tolong oleh teman anda untuk mengembalikan filenya yang telah dienkripsi oleh seseorang menggunakan bash script, file yang dimaksud adalah nature.zip. Karena terlalu mudah kalian memberikan syarat akan membuka seluruh file tersebut jika pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari jumat pada bulan Februari.
Hint: Base64, Hexdump
### Jawab:
Diketahui bahwa isi nature.zip adalah sebuah file terenkripsi yang berekstensi `.jpeg`. Ketika di buka akan muncul error karena header yang digunakan bukan merupakan header `.jpeg`. Oleh karena itu langkah awal yang harus dilakukan adalah mendekripsi Foto tersebut dengan base64 encoding. Hasil yang decode tersebut akan memberikan hexdump dari file tersebut, sehingga kita bisa mereturn hexdump tersebut ke biner aslinya dengan script `xxd` yang disediakan linux.
```
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
Untuk mendapatkan 

## Soal 3
Buatlah sebuah script bash yang dapat menghasilkan password secara acak sebanyak 12 karakter yang terdapat huruf besar, huruf kecil, dan angka. Password acak tersebut disimpan pada file berekstensi .txt dengan ketentuan pemberian nama sebagai berikut:
   * Jika tidak ditemukan file password1.txt maka password acak tersebut disimpan pada file bernama password1.txt
   * Jika file password1.txt sudah ada maka password acak baru akan disimpan pada file bernama password2.txt dan begitu seterusnya.
   * Urutan nama file tidak boleh ada yang terlewatkan meski filenya dihapus.
   * Password yang dihasilkan tidak boleh sama.
### Jawab:
Untuk mendapat kan random, kita bisa mengambil sebuah random generator yang disediakan oleh linux pada `/dev/urandom`. Dari random tersebut tentu kita harus mengambil hanya huruf kecil, huruf besar, dan angkanya saja, oleh karena itu kita bisa menggunakan fungsi `tr -dc 'a-zA-Z0-9'` yang berarti kita hanya mengambil lowercase a-z, uppercase A-Z, dan number dari random tersebut karena `tr -dc` berarti menghapus komplemen dari pola `'a-zA-Z0-9`, lalu kita bisa mengambil hanya 12 bagian pertamanya saja dengan `fold -w 12'` yang berarti mengambil hanya 12 bagian hurufnya.
```
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
   i=$((i+1))
 else
  echo "$res" > password$i.txt
  #echo "$res"
  exit
 fi
done
```
Karena terkadang `fold` mengambil 12 bagian pertama dari random generator tersebut terkadang tidak termasuk huruf kecil dan atau huruf besar serta angka, maka kita ulang ketika tidak memenuhi aturan dengan fungsi `randompassword()`
+ Fungsi `randompassword()` berfungsi untuk mengenerate password selama belum memenuhi kondisi **(a-zA-Z0-9)**
+ `if [ -f "$loc/password$i.txt" ]` berfungsi untuk mengecek apakah ada file password-n.txt, apabila ada maka
+ `awk '{print $1}' password$i.txt` kita ambil isi dari file password yang ada tersebut
+  `while [ "$pass" == "$res" ] do randompassword` lalu kita generate password baru apabila password baru tersebut sama dengan password yang sudah ada tersebut
+ `echo "$res" > password$i.txt exit` apabila sudah tidak sama dengan password lain dan pada password-n.txt yang belum tersedia, maka simpan dan exit dari script tersebut


4. Lakukan backup file syslog setiap jam dengan format nama file “jam:menit tanggal-bulan-tahun”. Isi dari file backup terenkripsi dengan konversi huruf (string manipulation) yang disesuaikan dengan jam dilakukannya backup misalkan sebagai berikut:
   * Huruf b adalah alfabet kedua, sedangkan saat ini waktu menunjukkan pukul 12, sehingga huruf b diganti dengan huruf alfabet yang memiliki urutan ke 12+2 = 14.
   * Hasilnya huruf b menjadi huruf n karena huruf n adalah huruf ke empat belas, dan seterusnya.
   * setelah huruf z akan kembali ke huruf a
   * Backup file syslog setiap jam.
   * dan buatkan juga bash script untuk dekripsinya.

5. Buatlah sebuah script bash untuk menyimpan record dalam syslog yang memenuhi kriteria berikut:
   * Tidak mengandung string “sudo”, tetapi mengandung string “cron”, serta buatlah pencarian stringnya tidak bersifat case sensitive, sehingga huruf kapital atau tidak, tidak menjadi masalah.
   * Jumlah field (number of field) pada baris tersebut berjumlah kurang dari 13.
   * Masukkan record tadi ke dalam file logs yang berada pada direktori /home/[user]/modul1.
   * Jalankan script tadi setiap 6 menit dari menit ke 2 hingga 30, contoh 13:02, 13:08, 13:14, dst.
