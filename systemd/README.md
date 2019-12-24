# **Sripts**
1. Service, который раз в 30 секунд мониторит лог на предмет наличия ключевого слова - [01-watchlog.sh](scripts/01-watchlog.sh).
2. Из репозитория epel установлен spawn-fcgi и переписан init-скрипт на unit-файл - [02-spawn-fcgi.sh](scripts/02-spawn-fcgi.sh).
3. Дополнен unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами - [03-apache-mult-instance.sh](scripts/03-apache-mult-instance.sh).
4. Задание со *:  Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл - [04-jira.sh](scripts/04-jira.sh).

# **Vagrantfile**
результирующий [VagrantFile](Vagrantfile) c примененением всех скриптов с помощью `Vagrant shell provisioner`.