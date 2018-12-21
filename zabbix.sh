#!/bin/bash

echo "docker precisa estar instalado!"

#instalando zabbix no docker

mkdir -p /docker/mysql/zabbix/data

docker pull mysql:5.7

docker pull zabbix/zabbix-agent:ubuntu-latest

docker pull zabbix/zabbix-proxy-sqlite3:ubuntu-latest

docker pull zabbix/zabbix-server-mysql:ubuntu-latest

docker pull zabbix/zabbix-web-apache-mysql:ubuntu-latest

docker run -d --name mysql-zabbix  --restart always  -p 3306:3306  -v /docker/mysql/zabbix/data:/var/lib/mysql  -e MYSQL_HOST=172.17.0.1  -e MYSQL_ROOT_PASSWORD=secret  -e MYSQL_DATABASE=zabbix  -e MYSQL_USER=zabbix  -e MYSQL_PASSWORD=zabbix  mysql:5.7

docker run -d --name zabbix-server  --restart always  -p 10051:10051  -e MYSQL_ROOT_PASSWORD="secret"  -e DB_SERVER_HOST="172.17.0.1"  -e DB_SERVER_PORT="3306"  -e MYSQL_USER="zabbix"  -e MYSQL_PASSWORD="zabbix"  -e MYSQL_DATABASE="zabbix" zabbix/zabbix-server-mysql:ubuntu-latest

docker run -d --name zabbix-web  --restart always  -p 80:80  -e DB_SERVER_HOST="172.17.0.1"  -e DB_SERVER_PORT="3306"  -e MYSQL_USER="zabbix"  -e MYSQL_PASSWORD="zabbix"  -e MYSQL_DATABASE="zabbix"  -e ZBX_SERVER_HOST="172.17.0.1"  -e PHP_TZ="America/Sao_Paulo"  zabbix/zabbix-web-apache-mysql:ubuntu-latest

docker run -d --name zabbix-agent  --restart always  -p 10050:10050  -e ZBX_HOSTNAME="$(hostname)"  -e ZBX_SERVER_HOST="172.17.0.1"  zabbix/zabbix-agent:ubuntu-latest
