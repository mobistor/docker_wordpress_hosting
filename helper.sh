#!/bin/sh
[ ! -f ./config ] && echo "config not found" && exit 1
[ -d ./vol/html ] || mkdir -p ./vol/html
[ -d ./vol/database ] || mkdir -p ./vol/database
[ -d ./vol/redis ] || mkdir -p ./vol/redis

. ./config

WP_CONT=$VID
DB_CONT=${VID}-db
RD_CONT=${VID}-rd

run() 
{
  docker run \
	-e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
        -e MYSQL_DATABASE=${MYSQL_DATABASE} \
	-e MYSQL_USER=${MYSQL_USER} \
	-e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
        --name ${DB_CONT} \
        -v "$PWD/vol/database":/var/lib/mysql \
        -d mariadb:latest

  docker run --name ${RD_CONT} \
	-v "$PWD/vol/redis":/data \
	-d redis

  docker run \
	-e WORDPRESS_DB_USER=${MYSQL_USER} \
	-e WORDPRESS_DB_PASSWORD=${MYSQL_PASSWORD} \
	-e WORDPRESS_DB_DATABASE=${MYSQL_DATABASE} \
	--memory="${MEMORY}" \
        --cpus="${CPUS}" \
        --name ${WP_CONT} \
        --link ${DB_CONT}:mysql \
	--link ${RD_CONT}:redis \
        --expose 80 \
        -v "$PWD/vol/html":/var/www/html \
        --env "VIRTUAL_HOST=${VHOST}" \
        --env "LETSENCRYPT_HOST=${VHOST}" \
        --env "LETSENCRYPT_EMAIL=${EMAIL}" \
        -d wordpress
}

start()
{
  docker container start ${DB_CONT} ${RD_CONT} ${WP_CONT} 
}

stop()
{
  docker container stop ${WP_CONT} ${RD_CONT} ${DB_CONT}
}

reset()
{
  [ -d ./vol ] && rm -rf ./vol 
}

clean()
{
  docker container rm ${DB_CONT} ${WP_CONT} ${RD_CONT}
}

case $1 in
  run)
	 run 
	 ;;
  stop)
	 stop
	 ;;
  start)
	 start
	 ;;
  restart)
	 stop
	 start
	 ;;
  reset)
	 stop
	 clean
	 reset
	 ;;
  clean)
	 stop
	 clean
	 ;;
  status)
	 docker container stats ${WP_CONT} ${RD_CONT} ${DB_CONT}
	 ;;
esac
