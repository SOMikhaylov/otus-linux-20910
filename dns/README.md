# **Настраиваем split-dns**

запуск
```
vagrant up
```

---

## Проверка

### client1
web1
```
[root@client ~]# nslookup web1 ns01
Server:		ns01
Address:	192.168.50.10#53

Name:	web1.dns.lab
Address: 192.168.50.15

[root@client ~]# nslookup web1 ns02
Server:		ns02
Address:	192.168.50.11#53

Name:	web1.dns.lab
Address: 192.168.50.15
```
web2
```
[root@client ~]# nslookup web2 ns01
Server:		ns01
Address:	192.168.50.10#53

** server can't find web2: NXDOMAIN

[root@client ~]# nslookup web2 ns02
Server:		ns02
Address:	192.168.50.11#53

** server can't find web2: NXDOMAIN
```
www.newdns.lab
```
[root@client ~]# nslookup www.newdns.lab ns01
Server:		ns01
Address:	192.168.50.10#53

Name:	www.newdns.lab
Address: 192.168.50.15
Name:	www.newdns.lab
Address: 192.168.50.16

[root@client ~]# nslookup www.newdns.lab ns02
Server:		ns02
Address:	192.168.50.11#53

Name:	www.newdns.lab
Address: 192.168.50.15
Name:	www.newdns.lab
Address: 192.168.50.16
```
---

### client2 

web1
```
[root@client2 ~]# nslookup web1 ns01
Server:		ns01
Address:	192.168.50.10#53

Name:	web1.dns.lab
Address: 192.168.50.15

[root@client2 ~]# nslookup web1 ns02
Server:		ns02
Address:	192.168.50.11#53

Name:	web1.dns.lab
Address: 192.168.50.15
```
web2
```
[root@client2 ~]# nslookup web2 ns01
Server:		ns01
Address:	192.168.50.10#53

Name:	web2.dns.lab
Address: 192.168.50.16

[root@client2 ~]# nslookup web2 ns02
Server:		ns02
Address:	192.168.50.11#53

Name:	web2.dns.lab
Address: 192.168.50.16
```
www.newdns.lab
```
[root@client2 ~]# nslookup www.newdns.lab ns01
Server:		ns01
Address:	192.168.50.10#53

** server can't find www.newdns.lab: NXDOMAIN

[root@client2 ~]# nslookup www.newdns.lab ns02
Server:		ns02
Address:	192.168.50.11#53

** server can't find www.newdns.lab: NXDOMAIN
```

---