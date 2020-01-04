# **RPM репозиторий**
- результирующий [Vagrantfile](Vagrantfile)
- [script](scripts/01-script.sh) со сборкой rpm пакета `nginx` c поддержкой `openssl` и помещением его в локальный репозиторий.

# **Задание со `*`: Docker образ c nginx c поддержкой openssl**
Собран основе `alpine` образ `nginx` c поддержкой `openssl`
- [Dockerfile](Dockerfile)
- ccылка на образ в DockerHub - https://hub.docker.com/repository/docker/somikhaylov/nginx-openssl
- Запуск 
```
docker run -d -p 80:80 somikhaylov/nginx-openssl:1.0
```
- проверка
```
curl http://localhost
```