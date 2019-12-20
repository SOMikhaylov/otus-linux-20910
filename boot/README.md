# **Попасть в систему без пароля несколькими способами**
### Способ 1 
1. В grub при выборе ядра нажимаем `e`. 
2. В строке начинающейся с `linux16` меняем `ro` на `rw` 
3. После `rw` все остальное удаляем и добавляем `init=/bin/sh`
> C помощью данного способа попадаем в систему c правами `root`
---
### Способ 2
1. В grub при выборе ядра нажимаем `e`. 
2. В строке начинающейся с `linux16` после `ro` все остальное удаляем и добавляем `rd.break`
> C помощью данного способа попадаем в initrd перед монтированием системы в корневой каталог. На данном этапе система смонтирована в `/sysroot` только на чтение
3. перомонтируем систему на чтение-запись
```  
mount -o remount,rw /sysroot
```
4. попадаем в систему с помощью `chroot`
```
chroot /sysroot
```
5. можем сменить пароль для `root`
```
passwd root
touch /.autorelabel
```
---
# **Установить систему с LVM, после чего переименовать VG**
переименована VG
```
vgrename VolGroup00 OtusRoot
```
изменено имя в конфигурационныз файлах
```
sed -i 's/VolGroup00/OtusRoot/g' /etc/fstab
sed -i 's/VolGroup00/OtusRoot/g' /etc/default/grub
sed -i 's/VolGroup00/OtusRoot/g' /boot/grub2/grub.cfg
```
пересоздан `initrd image`
```
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```
после перезагрузки
```
[root@lvm ~]# vgs
  VG       #PV #LV #SN Attr   VSize   VFree
  OtusRoot   1   2   0 wz--n- <38.97g    0 
```
---
# **Добавить модуль в initrd**
создан модуль
```
mkdir /usr/lib/dracut/modules.d/01test
cd /usr/lib/dracut/modules.d/01test
wget -O module-setup.sh https://gist.github.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85tps://gist.githubusercontent.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85/raw/80060b7b300e193c187bbcda4d8fdf0e1c066af9/gistfile1.txt
wget -O test.sh https://gist.githubusercontent.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0/raw/69598efd5c603df310097b52019dc979e2cb342d/gistfile1.txt
```
пересобран образ `initrd`
```
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
dracut -f -v
```
отредактирован `/etc/default/grub` удалены параметры `rghb` и `quiet`. Во время перезагрузки увиден пингвин.
```
Hello! You are in dracut module!

 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
```
---
# **Задание со `*`: перенос /boot, на LVM раздел**
установлен пропатченный grub2
```
cat > /etc/yum.repos.d/grub2.repo <<EOF
[grub2-path]
name=grub2-patch
baseurl=https://yum.rumyantsev.com/centos/7/x86_64/
EOF
```
```
yum install grub2-2.02-0.76.el7.x86_64 -y
```
перемонтирован раздел с `/boot` в `/mnt`
```
umount /boot
mount /dev/vda2 /mnt
```
скопированы данные загрузочного раздела в каталог /boot
```
rsync -avHPSAX /mnt/ /boot/
umount /mnt
```
инициализируем PV раздел
```
pvcreate /dev/vda2 --bootloaderareasize 1m
```
увеличиваем `lvm` раздел
```
vgextend VolGroup00 /dev/vda2
lvextend -l +100%FREE /dev/VolGroup00/LogVol00
```
пересоздан `initrd`
```
dracut -f -v
```
обновлен загрузчик
```
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-install /dev/vda
```
из `/etc/fstab` убрана строка с разделом `/boot`
```
UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot  xfs     defaults        0 0
```
после перезагрузки
```
[root@lvm ~]# lsblk 
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda                     252:0    0   41G  0 disk 
├─vda1                  252:1    0    1M  0 part 
├─vda2                  252:2    0    1G  0 part 
│ └─VolGroup00-LogVol00 253:0    0 38.4G  0 lvm  /
└─vda3                  252:3    0   39G  0 part 
  ├─VolGroup00-LogVol00 253:0    0 38.4G  0 lvm  /
  └─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
```