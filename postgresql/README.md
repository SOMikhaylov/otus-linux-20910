# **PostgreSQL**

запуск стенда

```
vagrant up
```

## Нot_standby репликация с использованием слотов

проверка

```
[root@master ~]# ps wax|grep sender
 7542 ?        Ss     0:00 postgres: wal sender process replication 192.168.1.200(35796) streaming 0/3000140
 7833 pts/0    R+     0:00 grep --color=auto sender
```
```
[root@slave ~]# ps wax|grep receiver
 7541 ?        Ss     0:00 postgres: wal receiver process   streaming 0/3000140
 7666 pts/0    R+     0:00 grep --color=auto receiver
```
```
[root@master ~]# su - postgres
Last login: Mon Apr 20 11:09:36 UTC 2020 on pts/0
-bash-4.2$ psql -c 'select * from pg_stat_replication;'
 pid  | usesysid |   usename   | application_name |  client_addr  | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  | write_lsn | flush_lsn | replay_lsn | wri
te_lag | flush_lag | replay_lag | sync_priority | sync_state 
------+----------+-------------+------------------+---------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+-----------+-----------+------------+----
-------+-----------+------------+---------------+------------
 7542 |    16384 | replication | walreceiver      | 192.168.1.200 |                 |       35796 | 2020-04-20 11:04:15.107888+00 |              | streaming | 0/3000140 | 0/3000140 | 0/3000140 | 0/3000140  |    
       |           |            |             0 | async
(1 row)
```

## Резервное копирование с помощью barman

Проверка
```
[root@backup ~]# su - barman
Last login: Tue Apr 21 07:19:38 UTC 2020 on pts/0
-bash-4.2$ barman check master
Server master:
        WAL archive: FAILED (please make sure WAL shipping is setup)
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
```

```
-bash-4.2$ barman switch-wal --archive master
The WAL file 000000010000000000000004 has been closed on server 'master'
Waiting for the WAL file 000000010000000000000004 from server 'master' (max: 30 seconds)
Processing xlog segments from streaming for master
        000000010000000000000004
-bash-4.2$ barman check master
Server master:
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
```

```
-bash-4.2$ barman backup master
Starting backup using postgres method for server master in /var/lib/barman/master/base/20200421T072340
Backup start at LSN: 0/5000060 (000000010000000000000005, 00000060)
Starting backup copy via pg_basebackup for 20200421T072340
Copy done (time: less than one second)
Finalising the backup.
This is the first backup for server master
WAL segments preceding the current backup have been found:
        000000010000000000000004 from server master has been removed
Backup size: 21.1 MiB
Backup end at LSN: 0/7000000 (000000010000000000000006, 00000000)
Backup completed (start time: 2020-04-21 07:23:40.115439, elapsed time: less than one second)
Processing xlog segments from streaming for master
        000000010000000000000005
```