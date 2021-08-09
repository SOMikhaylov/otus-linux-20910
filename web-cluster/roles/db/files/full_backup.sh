#!/bin/bash

mount -t nfs  backup1:/backup /mnt

if [ -n "$1" ]
then
    if [ -d "/backup/$1" ] 
    then 
        xtrabackup --backup --target-dir=/mnt/$1
    else 
        mkdir /mnt/$1
        xtrabackup --backup --target-dir=/mnt/$1
    fi
else
echo "No parameters found. Set base directory name, please. "
fi
umount /mnt