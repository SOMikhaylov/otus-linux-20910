#!/bin/bash

mount -t nfs  backup1:/backup /mnt

if [ -n "$1" ] || [ -n "$2" ]
then
    if [ -d "/backup/$1" ] 
    then 
        xtrabackup --backup --target-dir=/mnt/$1 --incremental-basedir=/mnt/$2
    else 
        mkdir /mnt/$1
        xtrabackup --backup --target-dir=/mnt/$1 --incremental-basedir=/mnt/$2
    fi
else
echo "No parameters found. Set incremental and base directory name, please. "
fi

umount /mnt