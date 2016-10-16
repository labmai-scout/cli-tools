#!/bin/bash

for DIR in `ls -vd */`;
do
       	if [ -d $DIR ];
       	then
       		cd $DIR;
       		docker-compose down && docker-compose up -d
       		cd -;
       	fi
done

docker ps
