

## First Container

```
docker run -i -t ubuntu
```

in the container:
```
apt-get update -qq
apt-get install -y curl
curl -L spiegel.de
# exit
```

```
docker ps -a
docker rename 6c ubul
docker start ubul
```

created 1 image
```
docker commit ubul web
```
This an "Artisan" image, don't use commit.

## Using a Dockerfile

```
docker build -t web:v5 .
```

Use this image

```
docker run -d -p 80 web:v5
```

## Environment variables

```
FOOD=donner
echo ${FOOD}
echo ${FOOD:-default}
echo ${FOOD:=def-andset}
echo ${FOOD:? required} # fails if not set
```

inject env var to a container
```
docker run -dP -e TITLE='Happy Friday' web:v7
```

Coffebreak afternoon:
```
docker run -dP \
  -e TITLE='Coffebrak friday' \
  -e COLOR=hotpink \
  web:v8
```

## Share an image

```
docker login ...
docker build -t lalyos/web:v8 .
docker push lalyos/web:v8
```


## Volumes


start web container serving local htm files:
```
docker run -dP -v $PWD:/var/www/html
```

## MariaDB

```
docker run -d --name mydb mariadb

## docker logs mydb

docker rm mydb

docker run -d --name mydb -e MARIADB_ROOT_PASSWORD=secret mariadb
```

now jump inside
```
docker exec -it mydb bash

mysql -u root -psecret mysql

create table vip (name varchar(20), age int);
insert into vip values ('Elon', 47);
insert into vip values ('Bill', 58);
insert into vip values ('Layos', 49);
select * from vip;
exit
```

print all records
```
docker exec -i mydb  mysql -psecret mysql <<< "select * from vip;"
```

starting a new DB with the leftover randomly name volume
```
docker run -d -v 487d9756b337b1df0f7464c4b1b72091cb3d42f8c5500eebffcac421c61c851d:/var/lib/mysql  --name mydb -e MARIADB_ROOT_PASSWORD=secret mariadb
```

### initial data

preapare sql
```
mkdir sql
cat > sql/init.sql <<EOF
use mysql;
create table vip (name varchar(20), age int);
insert into vip values ('Elon', 47);
insert into vip values ('Bill', 58);
insert into vip values ('Layos', 49);
# one more line ...
EOF
chmod +r sql/*
```

```
docker run -d \
  -v vipdb:/var/lib/mysql  \
  -v $PWD/sql:/docker-entrypoint-initdb.d \
  --name mydb \
  -e MARIADB_ROOT_PASSWORD=secret \
  mariadb
```


check the container logs, look for 2 lines after init.sql:
```
docker logs mydb |& grep -A2 init.sql
```

## Networks


```
# listing
docker network ls

# create a new
docker network create luft

docker run -dP --name=backend -e TITLE=backend --net=luft web:v8
docker run -it --net=luft lalyos/tool
# use your own image:
docker run -it --net=luft tool
docker run -d \
  --net=luft \
  -v vipdb:/var/lib/mysql  \
  -v $PWD/sql:/docker-entrypoint-initdb.d \
  --name mydb \
  -e MARIADB_ROOT_PASSWORD=secret \
  mariadb
```

inside of tool
```
curl backend
mysql -u root -psecret -h mydb mysql <<< 'select * from vip;'
```

## Tool

```
mkdir tool
touch tool/Dockerfile
cat > tool/Dockerfile <<EOF
FROM ubuntu
RUN apt-get update -qq
RUN apt-get install -y curl net-tools mysql-client
# one more line
EOF
```
build the image
```
docker build -t tool ./tool/
```

use the image:
```
docker run -it --net=luft tool
# inside
curl backend
mysql -u root -psecret -h mydb mysql <<< 'select * from vip;'
```

## Helper 

```
alias nuke='docker rm -f $(docker ps -qa)'
alias vip='docker exec -i mydb  mysql -psecret mysql <<< "select * from vip;"'
```