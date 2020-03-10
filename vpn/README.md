# **VPN**

### tap
```
cd tap/
vagrant up
ansible-playbook vpn.yml
```
проверка
```
[root@server ~]# iperf3 -s &                                               │[root@client ~]# iperf3 -c 10.10.10.1 -t 40 -i 5
[2] 6392                                                                   │Connecting to host 10.10.10.1, port 5201
[root@server ~]# iperf3: error - unable to start listener for connections: │[  4] local 10.10.10.2 port 42734 connected to 10.10.10.1 port 5201
Address already in use                                                     │[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
iperf3: exiting                                                            │[  4]   0.00-5.00   sec  57.2 MBytes  96.0 Mbits/sec    2    319 KBytes   
Accepted connection from 10.10.10.2, port 42732                            │    
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 42734        │[  4]   5.00-10.01  sec  57.8 MBytes  96.9 Mbits/sec   32    217 KBytes   
[ ID] Interval           Transfer     Bandwidth                            │    
[  5]   0.00-1.01   sec  10.7 MBytes  88.8 Mbits/sec                       │^C[  4]  10.01-11.00  sec  12.2 MBytes   103 Mbits/sec    0    255 KBytes 
[  5]   1.01-2.01   sec  11.6 MBytes  97.8 Mbits/sec                       │      
[  5]   2.01-3.00   sec  11.5 MBytes  97.5 Mbits/sec                       │- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   3.00-4.00   sec  10.7 MBytes  89.8 Mbits/sec                       │[ ID] Interval           Transfer     Bandwidth       Retr
[  5]   4.00-5.01   sec  11.3 MBytes  94.0 Mbits/sec                       │[  4]   0.00-11.00  sec   127 MBytes  97.1 Mbits/sec   34             send
[  5]   5.01-6.00   sec  10.1 MBytes  85.2 Mbits/sec                       │er
[  5]   6.00-7.01   sec  11.3 MBytes  94.8 Mbits/sec                       │[  4]   0.00-11.00  sec  0.00 Bytes  0.00 bits/sec                  receiv
[  5]   7.01-8.00   sec  12.0 MBytes   101 Mbits/sec                       │er
```

---

### tun
```
cd tun/
vagrant up
ansible-playbook vpn.yml
```
проверка
```
[root@server ~]# iperf3 -s &                                               │[root@client ~]# iperf3 -c 10.10.10.1 -t 40 -i 5
[1] 6337                                                                   │Connecting to host 10.10.10.1, port 5201
[root@server ~]# ----------------------------------------------------------│[  4] local 10.10.10.2 port 46414 connected to 10.10.10.1 port 5201
-                                                                          │[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
Server listening on 5201                                                   │[  4]   0.00-5.01   sec  59.6 MBytes  99.9 Mbits/sec   15    172 KBytes   
-----------------------------------------------------------                │    
Accepted connection from 10.10.10.2, port 46412                            │[  4]   5.01-10.01  sec  60.6 MBytes   102 Mbits/sec    3    258 KBytes   
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46414        │    
[ ID] Interval           Transfer     Bandwidth                            │^C[  4]  10.01-11.81  sec  23.4 MBytes   109 Mbits/sec    0    308 KBytes 
[  5]   0.00-1.01   sec  10.5 MBytes  86.9 Mbits/sec                       │      
[  5]   1.01-2.00   sec  10.6 MBytes  89.6 Mbits/sec                       │- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   2.00-3.01   sec  12.4 MBytes   104 Mbits/sec                       │[ ID] Interval           Transfer     Bandwidth       Retr
[  5]   3.01-4.00   sec  12.4 MBytes   105 Mbits/sec                       │[  4]   0.00-11.81  sec   144 MBytes   102 Mbits/sec   18             send
[  5]   4.00-5.01   sec  11.8 MBytes  98.6 Mbits/sec                       │er
[  5]   5.01-6.01   sec  12.0 MBytes   100 Mbits/sec                       │[  4]   0.00-11.81  sec  0.00 Bytes  0.00 bits/sec                  receiv
[  5]   6.01-7.00   sec  11.7 MBytes  98.8 Mbits/sec                       │er

```

---

### ras
```
cd ras/
vagrant up
ansible-playbook vpn.yml
```
проверка с хостовой машины
```
➜  ras git:(vpn) ✗ sudo openvpn --config client.conf
Sat Mar 21 20:49:45 2020 OpenVPN 2.4.4 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on May 14 2019
Sat Mar 21 20:49:45 2020 library versions: OpenSSL 1.1.1  11 Sep 2018, LZO 2.08
Sat Mar 21 20:49:45 2020 WARNING: No server certificate verification method has been enabled.  See http://openvpn.net/howto.html#mitm for more info.
Sat Mar 21 20:49:45 2020 TCP/UDP: Preserving recently used remote address: [AF_INET]192.168.10.10:1207
Sat Mar 21 20:49:45 2020 Socket Buffers: R=[212992->212992] S=[212992->212992]
Sat Mar 21 20:49:45 2020 UDP link local (bound): [AF_INET][undef]:1194
Sat Mar 21 20:49:45 2020 UDP link remote: [AF_INET]192.168.10.10:1207
Sat Mar 21 20:49:45 2020 TLS: Initial packet from [AF_INET]192.168.10.10:1207, sid=f46beb9d 37cb6d88
Sat Mar 21 20:49:45 2020 VERIFY OK: depth=1, CN=rasvpn
Sat Mar 21 20:49:45 2020 VERIFY OK: depth=0, CN=rasvpn
Sat Mar 21 20:49:45 2020 Control Channel: TLSv1.2, cipher TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA
Sat Mar 21 20:49:45 2020 [rasvpn] Peer Connection Initiated with [AF_INET]192.168.10.10:1207
Sat Mar 21 20:49:46 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:49:51 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:49:56 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:50:01 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:50:06 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:50:11 2020 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Sat Mar 21 20:50:11 2020 PUSH: Received control message: 'PUSH_REPLY,route 10.10.10.0 255.255.255.0,topology net30,ping 10,ping-restart 120,ifconfig 10.10.10.6 10.10.10.5,peer-id 0,cipher AES-256-GCM'
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: timers and/or timeouts modified
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: --ifconfig/up options modified
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: route options modified
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: peer-id set
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: adjusting link_mtu to 1625
Sat Mar 21 20:50:11 2020 OPTIONS IMPORT: data channel crypto options modified
Sat Mar 21 20:50:11 2020 Data Channel: using negotiated cipher 'AES-256-GCM'
Sat Mar 21 20:50:11 2020 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sat Mar 21 20:50:11 2020 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sat Mar 21 20:50:11 2020 ROUTE_GATEWAY 192.168.43.1/255.255.255.0 IFACE=wlp3s0 HWADDR=24:fd:52:2a:fb:38
Sat Mar 21 20:50:11 2020 TUN/TAP device tun0 opened
Sat Mar 21 20:50:11 2020 TUN/TAP TX queue length set to 100
Sat Mar 21 20:50:11 2020 do_ifconfig, tt->did_ifconfig_ipv6_setup=0
Sat Mar 21 20:50:11 2020 /sbin/ip link set dev tun0 up mtu 1500
Sat Mar 21 20:50:11 2020 /sbin/ip addr add dev tun0 local 10.10.10.6 peer 10.10.10.5
Sat Mar 21 20:50:11 2020 /sbin/ip route add 10.10.10.0/24 via 10.10.10.5
Sat Mar 21 20:50:11 2020 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Sat Mar 21 20:50:11 2020 Initialization Sequence Completed
```
```
➜  ras git:(vpn) ✗ ping -c 4 10.10.10.1             
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.478 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=1.21 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.953 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=1.64 ms
```

---