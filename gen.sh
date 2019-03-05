#!/bin/sh

[ -z $1 ] && echo "$0 domain_name" && exit 1
[ -d ./vhosts ] || mkdir -p vhosts
[ -d ./vhosts/$1 ] && echo "$1 already exists!" && exit 1

cp -dpfR ./template ./vhosts/$1


