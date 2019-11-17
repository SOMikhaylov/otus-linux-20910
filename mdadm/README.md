# **Конфигурация RAID**
запуск [виртуальной машины](../Vagrantfile)
```
vagrant up 
vagrant ssh
sudo -i
```
просмотр дисков
```
[root@otuslinux ~]# fdisk -l |grep dev/sd*
Disk /dev/sda: 42.9 GB, 42949672960 bytes, 83886080 sectors
/dev/sda1   *        2048    83886079    41942016   83  Linux
Disk /dev/sdb: 262 MB, 262144000 bytes, 512000 sectors
Disk /dev/sdc: 262 MB, 262144000 bytes, 512000 sectors
Disk /dev/sdd: 262 MB, 262144000 bytes, 512000 sectors
Disk /dev/sde: 262 MB, 262144000 bytes, 512000 sectors
```
обнуление суперблоков
```
mdadm --zero-superblock --force /dev/sd{b,c,d,e}
```
сборка raid 10
```
mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/sd{b,c,d,e}
```

---
# **Проверка сборки RAID**
```
[root@otuslinux ~]# cat /proc/mdstat
Personalities : [raid10] 
md0 : active raid10 sde[3] sdd[2] sdc[1] sdb[0]
      507904 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      
unused devices: <none>
```
```
[root@otuslinux ~]# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Nov 16 15:44:26 2019
        Raid Level : raid10
        Array Size : 507904 (496.00 MiB 520.09 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Sat Nov 16 15:44:34 2019
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 9417aa62:721433e4:aff37404:d5bec849
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
```
---

# **Конфигурационный файл**
создае конфигурационный файл mdadm.conf
```
mdadm --detail --scan --verbose
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
```
# **Script сборки RAID**
[mdadm.sh](scripts/mdadm.sh)

---
# **Поломка RAID** 
```
[root@otuslinux ~]# mdadm /dev/md0 --fail /dev/sde
mdadm: set /dev/sde faulty in /dev/md0
```
```
[root@otuslinux ~]# mdadm /dev/md0 --remove /dev/sde
mdadm: hot removed /dev/sde from /dev/md0
```
проверка
```
cat /proc/mdstat
mdadm -D /dev/md0
```
---

# **Восстановление RAID** 
```
[root@otuslinux ~]# mdadm /dev/md0 --add /dev/sde
mdadm: added /dev/sde
```
проверка
```
cat /proc/mdstat
mdadm -D /dev/md0
```

# **Создание GPT раздела и 5 партиций**
создание GPT раздела
```
parted -s /dev/md0 mklabel gpt
```
создание 5 партиций
```
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 0% 40%
parted /dev/md0 mkpart primary ext4 0% 60%
parted /dev/md0 mkpart primary ext4 0% 80%
parted /dev/md0 mkpart primary ext4 0% 100%
```
создание на них файлов системы
```
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
```
монтирование по каталогам
```
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
```
---
# Задание со * : Vagrantfile, который сразу собирает систему с подключенным рейдом

скрипт [mdadm.sh](scripts/mdadm.sh) добавлен в provision [Vagrantfile](Vagrantfile)

---
