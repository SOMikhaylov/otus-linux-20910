# Установка ansible
```
pip install ansible --user
```
# Vagrant
[Vagrantfile](Vagrantfile)
```
vagrant up 
vagrant ssh-config
```
# Задание со *: Роль
создание роли
```
ansible-galaxy init roles/nginx
```
[nginx.yml](nginx.yml) - плейбук использующий роль
```
ansible-playbook nginx.yml
```