#!/bin/bash

SERVERID=$SPHINX_SERVER_ID

if [ "${SERVERID}" == "" ];
then
    SERVERID=1
fi

DIR=$(dirname $0)

curl "http://$PRODUCT_SERVER_HOST:$PRODUCT_SERVER_PORT/ajax/sphinx/get-conf/${SERVERID}" -o $DIR/conf.d/sphinx.conf

if [ "$?" == "" ];
then
    exit 1
fi

cat $DIR/sphinx.conf
for FILE in `ls $DIR/conf.d/*.conf`
do
	cat $FILE
done
