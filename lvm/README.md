# **Работа с LVM**
запуск [виртуальной машины](./Vagrantfile)
```
vagrant up 
vagrant ssh
sudo -i
```
---
# **Уменьшение тома с корневым разделом до 8G**
подготовлен временный том для / раздела
```
pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root
```
создана файловая система и смонтирован раздел
```
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt
```
скопированы данные с / раздела в /mnt
```
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
```
сделан `chroot` в `/mnt` и переконфигурирован загрузчик и 
```
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt
grub2-mkconfig -o /boot/grub2/grub.cfg
exit
```
обновлен `initrd`
```
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
```
в `/boot/grub2/grub.cfg` заменен `rd.lvm.lv=VolGroup00/LogVol00` на `rd.lvm.lv=vg_root/lv_root`. Ситуация после перезагрузки
```
[root@lvm ~]# lsblk 
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk 
├─sda1                    8:1    0    1M  0 part 
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part 
  ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm  
sdb                       8:16   0   10G  0 disk 
└─vg_root-lv_root       253:0    0   10G  0 lvm  /
sdc                       8:32   0    2G  0 disk 
sdd                       8:48   0    1G  0 disk 
sde                       8:64   0    1G  0 disk 
```
---
# **Создание разделов**
удален старый раздел
```
lvremove /dev/VolGroup00/LogVol00
```
создан новый том с 8GB под / раздел 
```
lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
```
создан раздел под /var в зеркало
```
pvcreate /dev/sdc /dev/sdd
vgcreate vg_var /dev/sdc /dev/sdd
lvcreate -L 950M -m1 -n lv_var vg_var
mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
rsync -avHPSAX /var/ /mnt/
mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
umount /mnt
mount /dev/vg_var/lv_var /var
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
```
проведена перезагрузка. Удален временный lvm
```
lvremove /dev/vg_root/lv_root
vgremove /dev/vg_root
pvremove /dev/sdb
```
выделен том под /home
```
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
```
---
# **Работа со снапшотами**
сгенерированы файлы в /home
```
touch /home/file{1..20}
```
снят снапшот
```
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
```
удалены файлы
```
rm -f /home/file{11..20}
```
```
[root@lvm ~]# ls /home/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9  vagrant
```
данные восстановлены со снапшота
```
umount -l /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home
```
```
[root@lvm ~]# ls /home/
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
```
---

# **Задание со `*`**
на разделе `/dev/sdb` создана файловая система `btrfs` и раздел примонтирован в `/mnt`
```
mkfs.btrfs /dev/sdb
mount /dev/sdb /mnt
```
созданы subvolume - один для размещения `/opt`
```
btrfs sub create /mnt/vol_opt
```
скопирован `/opt`
```
rsync -avHPSAX /opt/ /mnt/vol_opt
```
получены id subvolume (нужны для монтирования subvolume)
```
[root@lvm ~]# btrfs subvolume show /mnt/vol_opt
/mnt/vol_opt
	Name: 			vol_opt
	UUID: 			d7704a0a-bfa2-5f49-a4f9-9ae8635325ec
	Parent UUID: 		-
	Received UUID: 		-
	Creation time: 		2019-12-14 14:45:53 +0000
	Subvolume ID: 		257
	Generation: 		7
	Gen at creation: 	7
	Parent ID: 		5
	Top level ID: 		5
	Flags: 			-
	Snapshot(s):
```
добавлены в `/etc/fstab` опции монтирования `btrfs` раздела в `/opt` и `/snap` и проведена перезагрузка
```
[root@lvm ~]# blkid |grep sdb
/dev/sdb: UUID="df6448cb-a368-44d7-bb62-9db9d37fb645" UUID_SUB="4894c6b5-0c3e-4e91-830c-217a1c28197a" TYPE="btrfs"
```
```
...
UUID=df6448cb-a368-44d7-bb62-9db9d37fb645 /opt          btrfs   defaults,subvolid=257        0 0
```
после перезагрузки
```
[root@lvm ~]# btrfs subvolume show /opt
/opt
	Name: 			vol_opt
	UUID: 			d7704a0a-bfa2-5f49-a4f9-9ae8635325ec
	Parent UUID: 		-
	Received UUID: 		-
	Creation time: 		2019-12-14 14:45:53 +0000
	Subvolume ID: 		257
	Generation: 		8
	Gen at creation: 	7
	Parent ID: 		5
	Top level ID: 		5
	Flags: 			-
	Snapshot(s):
```
### работа со снапшотами
созданы файлы в `/opt`
```
[root@lvm ~]# touch /opt/file{1..10}
[root@lvm ~]# ls /opt/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9
```
перемонтирован `/opt` в корневой volume
```
umount /opt
mount -o subvolid=5 /dev/sdb /opt
```
сделан snapshot
```
btrfs subvolume snapshot -r /opt/vol_opt /opt/vol_snap
```
```
[root@lvm ~]# btrfs subvolume show /opt/vol_snap/
/opt/vol_snap
	Name: 			vol_snap
	UUID: 			830ddd05-a698-9142-8a17-0425e613672b
	Parent UUID: 		d7704a0a-bfa2-5f49-a4f9-9ae8635325ec
	Received UUID: 		-
	Creation time: 		2019-12-14 14:52:25 +0000
	Subvolume ID: 		258
	Generation: 		13
	Gen at creation: 	13
	Parent ID: 		5
	Top level ID: 		5
	Flags: 			readonly
	Snapshot(s):
```
обратно перемонтирован /opt в subvolume
```
umount /opt
mount -o subvolid=257 /dev/sdb /opt
```
удалены файлы из `/opt`
```
rm -rf /opt/*
```
проведено восстановление со снапшота
```
umount /opt
mount -o subvolid=5 /dev/sdb /opt
rsync -avHPSAX /opt/vol_snap/ /opt/vol_opt/
umount /opt
mount -o subvolid=257 /dev/sdb /opt
```
```
[root@lvm ~]# ls /opt/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9
```