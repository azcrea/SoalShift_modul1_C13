loc=$(pwd)
#mkdir /home/duhbuntu/modul1
awk '/cron/ || /CRON/,!/sudo/' /var/log/syslog | awk 'NF < 13' >> /home/duhbuntu/modul1/nomor5.log

2-30/6 * * * * /bin/bash /home/duhbuntu/sisop/prak1/soal5.sh
