# **PostgreSQL**

запуск стенда

```
vagrant up
```

## Нot_standby репликация с использованием слотов

проверка

```
[root@master ~]# ps wax|grep sender
25203 ?        Ss     0:00 postgres: wal sender process replication 192.168.1.200(37264) streaming 0/3000060
25283 pts/0    S+     0:00 grep --color=auto sender
```
```
[root@slave ~]# ps wax|grep receiver
22185 ?        Ss     0:00 postgres: wal receiver process   streaming 0/3000060
25314 pts/0    R+     0:00 grep --color=auto receiver
```

```
[root@master ~]# su - postgres
Last login: Sun Apr 19 14:47:45 UTC 2020 on pts/0
[postgres@master ~]$

[postgres@master ~]$  psql -c 'SELECT *,pg_xlog_location_diff(s.sent_location,s.replay_location) byte_lag FROM pg_stat_replication s;'
  pid  | usesysid |   usename   | application_name |  client_addr  | client_hostname | client_port |         backend_start         | backend_xmin |   
state   | sent_location | write_location | flush_location | replay_location | sync_priority | sync_state | byte_lag 
-------+----------+-------------+------------------+---------------+-----------------+-------------+-------------------------------+--------------+---
--------+---------------+----------------+----------------+-----------------+---------------+------------+----------
 25203 |    16384 | replication | walreceiver      | 192.168.1.200 |                 |       37264 | 2020-04-19 14:42:47.731215+00 |              | st
reaming | 0/3000140     | 0/3000140      | 0/3000140      | 0/3000140       |             0 | async      |        0
(1 row)
```

## Резервное копирование с помощью barman

