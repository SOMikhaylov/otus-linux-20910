# Простая защита от ДДОС

проверка
```
docker run -p 80:80 somikhaylov/nginx-ddos:latest
```
```
➜  ddos git:(master) ✗ curl http://localhost/otus.txt            
<html>
<head><title>302 Found</title></head>
<body>
<center><h1>302 Found</h1></center>
<hr><center>nginx/1.17.9</center>
</body>
</html>
➜  ddos git:(master) ✗ curl -b botcheck=1 localhost/otus.txt
somikhaylov
```
