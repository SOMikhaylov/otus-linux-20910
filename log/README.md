# Центральный сервер для сбора логов
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
- стартовая страница `nginx` - http://192.168.11.100

---
# Задание со *: направление логов nginx в elk

установка и конфигурация `elasticsearch`, `kinana`, `logstash` на сервере `elk`
```
ansible-playbook elk.yml
```
установка `filebeat` на сервере `web`
```
ansible-playbook filebeat.yml
```

- интерфейс kibana - http://192.168.11.102:5601