

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
docker built -t web:v5 .
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



## Helper 

```
alias nuke='docker rm -f $(docker ps -qa)'
```