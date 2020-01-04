# **Docker образ nginx на базе alpine**
cборка образа ([Dockerfile](nginx/Dockerfile))
```
docker build -t somikhaylov/nginx:1.0 .
```
ссылка на образ в docker hub
```
https://hub.docker.com/repository/docker/somikhaylov/nginx
```
запуск контейнера
```
docker run -d -p 80:80 --name mynginx somikhaylov/nginx:1.0
```
### Ответы на вопросы:
> Определите разницу между контейнером и образом
1. Файловая система `(UnionFS)` контейнера имеет на 1 слой больше чем у образа. Этот дополнительный слой доступен для записи (остальные слои доступны только для чтения). 


> Можно ли в контейнере собрать ядро?

2. Docker контейнер использует ядро хостовой системы и не имеет своего собственного ядра.
---
# **Задание со `*`: docker-compose**
1. образ c php-fpm - [Dockerfile](php-fpm/Dockerfile)
- ссылка на образ в docker hub - https://hub.docker.com/repository/docker/somikhaylov/php-fpm
2. docker-compose - [docker-compose.yml](./docker-compose.yml)
```
docker-compose up
```