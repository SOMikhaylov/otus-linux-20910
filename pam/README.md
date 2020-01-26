# **PAM**

Результирующий [Vagrantfile](Vagrantfile)

# Основное задание

- создана группа `admin`
- в группу `admin` добавлены пользователи `vagrant`, `root`
- создан пользователь `test` c паролем `test`, для тестирования работы других пользователей
- добавлен модуль `pam_time`
- добавлен конфиг в `/etc/security/time.conf` для запрета доступа всем пользователям в выходные дни кромен группы `admin`

результирующий плейбук - [admin_rule.yml](admin_rule.yml)

# Задание со *

- установлен `docker`
- пользователю `vagrant` даны права на работу с `docker` и права на рестарт `docker.service` c помощью `polkit`. 

результирующий плейбук - [docker_rule.yml](docker_rule.yml)

> для более тонкой настройки polkit требуется версия systemd 226, в текущей версии centos7.6 используется 219.

> в версии 226 можно использовать переменные `unit` и `verb`. В текущей версии они не определены.
```
Jan 26 13:22:38 centos7 polkitd[1223]: /etc/polkit-1/rules.d/01-docker.rule│
s:5: unit=undefined                                                        │
Jan 26 13:22:38 centos7 polkitd[1223]: /etc/polkit-1/rules.d/01-docker.rule│
s:6: verb=undefined 
```
> в случае использования systemd 226 - правило выглядела бы так: 
```
 polkit.addRule(function(action, subject) {
     var debug = true;
     if (action.id == "org.freedesktop.systemd1.manage-units" &&
         action.lookup("unit") == "docker.service" &&
         action.lookup("verb") == "restart" &&
         subject.user == "vagrant") {
         return polkit.Result.YES;
     }
 });
```
> появилась бы возможность настроить права для команды рестарт и только для юнита `docker.service`.