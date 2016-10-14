#!/bin/bash

for DIR in `ls -d *`;
do
       	if [ -d $DIR ];
       	then
       		cd $DIR;
       		docker-compose down
       		cd -;
       	fi
done

docker ps
