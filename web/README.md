# Роль для настройки веб сервера

запуск стенда
```
vagrant up
```
- `webserver` настраивается с помощью `ansible` ролей используемых в [provision.yml](provision.yml)
- с локальной машины проброшены порты с помощью `vagrant`
- на `webserver` перенаправление через nginx
---

# Проверка



- http://127.0.0.1:8080 - дефолтная страница nginx
- http://127.0.0.1:8081 - wordpress на php-fpm + mysql
- http://127.0.0.1:8082 - kibana (elk)
- http://127.0.0.1:8083 - grafana
