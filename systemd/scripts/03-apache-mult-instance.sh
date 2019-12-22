#!/bin/bash
sed -i 's/sysconfig\/httpd/sysconfig\/httpd-%I/g' /lib/systemd/system/httpd.service
