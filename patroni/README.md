# **Разворачиваем кластер Patroni**

Запуск
```
vagrant up
ansible-playbook site.yml -i hosts
```

## Проверка

```
root@pg1:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 |        | running |  1 |         0 |
|   otus  |  pg2   | 192.168.11.121 | Leader | running |  1 |           |
|   otus  |  pg3   | 192.168.11.123 |        | running |  1 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
```
коннект с мастер ноде и создание базы
```
root@pg1:~# psql -h 192.168.11.121 --username=postgres
Password for user postgres: 
psql (12.2 (Ubuntu 12.2-2.pgdg18.04+1), server 11.7 (Ubuntu 11.7-2.pgdg18.04+1))
Type "help" for help.

postgres=# create database otus;
CREATE DATABASE
```

### failover 
```
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 |        | running |  1 |         0 |
|   otus  |  pg2   | 192.168.11.121 | Leader | running |  1 |           |
|   otus  |  pg3   | 192.168.11.123 |        | running |  1 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
root@pg2:~# systemctl stop patroni
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 |        | running |    |   unknown |
|   otus  |  pg2   | 192.168.11.121 |        | stopped |    |   unknown |
|   otus  |  pg3   | 192.168.11.123 | Leader | running |  2 |           |
+---------+--------+----------------+--------+---------+----+-----------+
```

### switchover

```
root@pg2:~# patronictl -c /etc/patroni/patroni.yml switchover
Master [pg3]: 
Candidate ['pg1'] []: 
When should the switchover take place (e.g. 2020-04-21T17:09 )  [now]: 
Current cluster topology
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 |        | running |  2 |         0 |
|   otus  |  pg3   | 192.168.11.123 | Leader | running |  2 |           |
+---------+--------+----------------+--------+---------+----+-----------+
Are you sure you want to switchover cluster otus, demoting current master pg3? [y/N]: y
2020-04-21 16:09:32.23565 Successfully switched over to "pg1"
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  2 |           |
|   otus  |  pg3   | 192.168.11.123 |        | stopped |    |   unknown |
+---------+--------+----------------+--------+---------+----+-----------+
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  3 |           |
|   otus  |  pg3   | 192.168.11.123 |        | running |  3 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
root@pg2:~# systemctl start patroni.service 
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  3 |           |
|   otus  |  pg2   | 192.168.11.121 |        | running |  1 |        16 |
|   otus  |  pg3   | 192.168.11.123 |        | running |  3 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
```

### Изменение требующее рестарта

```
root@pg2:~# patronictl -c /etc/patroni/patroni.yml edit-config
--- 
+++ 
@@ -7,7 +7,7 @@
       archive-push -B /var/backup --instance dbdc2 --wal-file-path=%p --wal-file-name=%f
       --remote-host=10.23.1.185
     archive_mode: 'on'
-    max_connections: 100
+    max_connections: 101
     max_parallel_workers: 8
     max_wal_senders: 5
     max_wal_size: 2GB

Apply these changes? [y/N]: y
Configuration changed
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list
+---------+--------+----------------+--------+---------+----+-----------+-----------------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB | Pending restart |
+---------+--------+----------------+--------+---------+----+-----------+-----------------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  3 |           |        *        |
|   otus  |  pg2   | 192.168.11.121 |        | running |  3 |         0 |        *        |
|   otus  |  pg3   | 192.168.11.123 |        | running |  3 |         0 |        *        |
+---------+--------+----------------+--------+---------+----+-----------+-----------------+
```

делаем рестарт
```
root@pg2:~# patronictl -c /etc/patroni/patroni.yml restart otus
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  3 |           |
|   otus  |  pg2   | 192.168.11.121 |        | running |  3 |         0 |
|   otus  |  pg3   | 192.168.11.123 |        | running |  3 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
When should the restart take place (e.g. 2020-04-21T17:17)  [now]: 
Are you sure you want to restart members pg1, pg2, pg3? [y/N]: y
Restart if the PostgreSQL version is less than provided (e.g. 9.5.2)  []: 
Success: restart on member pg1
Success: restart on member pg2
Success: restart on member pg3
root@pg2:~# patronictl -c /etc/patroni/patroni.yml list otus
+---------+--------+----------------+--------+---------+----+-----------+
| Cluster | Member |      Host      |  Role  |  State  | TL | Lag in MB |
+---------+--------+----------------+--------+---------+----+-----------+
|   otus  |  pg1   | 192.168.11.120 | Leader | running |  3 |           |
|   otus  |  pg2   | 192.168.11.121 |        | running |  3 |         0 |
|   otus  |  pg3   | 192.168.11.123 |        | running |  3 |         0 |
+---------+--------+----------------+--------+---------+----+-----------+
```