#!/bin/bash

cmd()
{
  [ -f ./config ] && ./helper.sh $1 
}
for host in $(ls ./vhosts/) 
do
   echo $host
   cd ./vhosts/$host
   cmd $1 $host
   cd ../..
done
