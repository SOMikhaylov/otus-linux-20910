# Разворачиваем сетевую лабораторию

[Vagrantfile](Vagrantfile)

***Схема стенда***

![Схема стенда](netlab.png)

---

# **Описание сетей**

***router-net***

Netmask: 255.255.255.252<br>
Network: 192.168.255.0/30<br>
Broadcast: 192.168.255.3<br>
HostMin: 192.168.255.1<br>
HostMax: 192.168.255.2<br>
Hosts/Net: 2<br>

***dir-net***

Netmask: 255.255.255.240<br>
Network: 192.168.10.0/28<br>
Broadcast: 192.168.10.15<br>
HostMin: 192.168.10.1<br>
HostMax: 192.168.10.14<br>
Hosts/Net: 14<br>

***office1-net***

Netmask: 255.255.255.0<br>
Network: 192.168.2.0/24<br>
Broadcast: 192.168.2.255<br>
HostMin: 192.168.2.1<br>
HostMax: 192.168.2.254<br>
Hosts/Net: 254<br>

***office2-net***

Netmask: 255.255.255.0<br>
Network: 192.168.1.0/24<br>
Broadcast: 192.168.1.255<br>
HostMin: 192.168.1.1<br>
HostMax: 192.168.1.254<br>
Hosts/Net: 254<br>

# **Проверка**
```
[root@office1Server ~]# traceroute ya.ru
traceroute to ya.ru (87.250.250.242), 30 hops max, 60 byte packets
 1  gateway (192.168.2.1)  0.775 ms  0.325 ms  0.331 ms
 2  192.168.10.1 (192.168.10.1)  0.636 ms  0.351 ms  0.703 ms
 3  192.168.255.1 (192.168.255.1)  0.903 ms  1.468 ms  1.408 ms
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  ns-kem252br-te1-5-2900.ll-kem.zsttk.ru (81.1.200.233)  7.781 ms * *
 9  kmo01.transtelecom.net (217.150.44.118)  13.171 ms  6.962 ms  4.002 ms
10  mskn17ra-lo1.transtelecom.net (217.150.55.21)  48.197 ms  47.932 ms  48.282 ms
11  Yandex-gw.transtelecom.net (188.43.3.213)  48.931 ms  47.085 ms  45.772 ms
12  ya.ru (87.250.250.242)  52.326 ms  48.952 ms vla-32z2-eth-trunk1-1.yndx.net (93.158.172.51)  50.127 ms
```