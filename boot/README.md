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