#!/bin/bash

mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
mdadm --create  /dev/md0 -l 10 -n 4 /dev/sd{b,c,d,e}
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf