# **Script**
Script [script.sh](./scripts/01-script.sh) парсит каждый час [access.log](./access-4560-644067.log) отправляя письмо со статистикой на root@localhost. Script добавлен в сron пользователя root. Результирующий [Vagrantfile](Vagrantfile).

1. Парсинг осуществляется с помощью функций использующих `sed` и `awk`. 
```
....
parse_hour_access_log
topIP
topRequests
allErrors
allExitStatus
sendStats
....
```
2. реализована зашита от мультзапуска с помощью создания PID файла
```
if [ -e $PID ]
then
    echo "Process can not start. It's run already."
    exit 0
else
    echo $$ > $PID
    echo "$PID has created"
fi
```
3. реализован перехват сигнала для корректного удаления файла
```
trap 'rm -f $PID; echo "$PID has removed"' INT TERM EXIT
```