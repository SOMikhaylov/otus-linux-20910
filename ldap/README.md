# **Установка FreeIPA**
[Vagrantfile](Vagrantfile)
```
vagrant up
```
**Задание с `**`** : настройка `firewalld` для работы `freeipa`
```
ansible-playbook firewalld.yml
```
уставновка ipa-server
```
ansible-playbook ipa-server.yml
```
уставновка ipa-client
```
ansible-playbook ipa-client.yml
```
# **Создание учетной записи и Задание со `*`: Настройка авторизации по ssh ключам**
```
ansible-playbook ipa-create-user.yml
```
проверка авторизации по ssh ключам
```
vagrant ssh client
Last login: Wed Jan 29 11:19:55 2020 from 192.168.11.1
[vagrant@client ~]$ sudo -i
[root@client ~]# ssh user@server
Could not chdir to home directory /home/user: No such file or directory
-sh-4.2$ 
```