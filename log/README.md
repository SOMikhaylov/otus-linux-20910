# Центральный сервер для сбора логов

* web - ip: 192.168.11.100
* log - ip: 192.168.11.101
* elk - ip: 192.168.11.102

установка и конфигурирование
```
bash start.sh
```
либо 

[Vagrantfile](Vagrantfile)
```
vagrant up
```
установка `nginx` на сервер `web`
```
ansible-playbook nginx.yml
```
конфигурация `rsyslog` - все логи с `web` отправляются на сервер `log`
```
ansible-playbook rsyslog.yml
```
- стартовая страница `nginx` - http://192.168.11.100;
- все логи c сервера `web`, кроме логов `nginx`  падают в файл /var/log/web.log на сервере `log`, в том числе и логи auditd (включая логи доступа к /etc/nginx/nginx.conf);
- конфигурация в /etc/rsyslog.conf на сервере web (клиентская) и на сервере log (серверная).

---
# Задание со *: направление логов nginx в elk

установка и конфигурация `elasticsearch`, `kinana`, `logstash` на сервере `elk`
```
ansible-playbook elk.yml
```

- интерфейс kibana - http://192.168.11.102:5601;
- логи `nginx` отправляются `rsyslog` в `logstash` на сервер `elk`.
- отправка логов `nginx` на клиентской части описана в конфигурационном файле /etc/nginx/nginx.conf;
```
    access_log  syslog:server=192.168.11.102:5044  main;
    error_log syslog:server=192.168.11.102:5044;
    error_log /var/log/nginx/error.log crit
```