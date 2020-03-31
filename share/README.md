# Vagrant стенд для SAMBA
запуск
```
vagrant up
```
`server` и `client` настраиваются с помощью роли roles/samba.

### Server

- расшарена сетевая папка `smbshare` (путь на сервере /srv/smbshare)
- в сетевой папке в соответсвии с задание создана папка upload c правами на запись
- `selinux` не отключен (в режиме enforcing ). Для сетевой папки настроен контекст `selinux`
- включен и настроен `firewalld`

### Client
- монтирует сетевую папку `smbshare` в каталог `/mnt` с помощью `/etc/fstab`
- selinux не отключен (в режиме enforcing) 
- включен `firewalld`