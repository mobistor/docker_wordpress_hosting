#!/bin/sh

[ -z $1 ] && echo "$0 domain_name" && exit 1
[ -d ./vhost/$1 ] && echo "$1 already exists!" && exit 1

cp -dpfR ./template ./vhost/$1


