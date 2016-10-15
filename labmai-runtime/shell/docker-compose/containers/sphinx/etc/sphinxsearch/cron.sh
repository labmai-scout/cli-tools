#!/bin/bash

## add cron
## 25 */3 * * * root docker exec -t hub-product sh -lc '/etc/sphinxsearch/cron.sh'

pidFile="/tmp/sphinx.cron.sh.pid"
if [ -f "$pidFile" ];
then
    rawPID=`cat ${pidFile}`
    pidPath="/proc/${rawPID}"
    if [ -d "$pidPath" ];
    then
        exit
    fi
fi

pid=$$
`echo $pid > $pidFile`

SERVERID=$SPHINX_SERVER_ID
if [ "${SERVERID}" == "" ];
then
    SERVERID=1
fi
DIR=$(dirname $0)

indexer --config /etc/sphinxsearch/sphinx.conf.sh --rotate delta && indexer --config /etc/sphinxsearch/sphinx.conf.sh --rotate --merge product_local delta
if [ "$?" -gt "0" ];
then
    curl -sLo /dev/null "http://$PRODUCT_SERVER_HOST:$PRODUCT_SERVER_PORT/ajax/sphinx/notif-rotate/delta/${SERVERID}"
    indexer --config /etc/sphinxsearch/sphinx.conf.sh --rotate --all
    if [ "$?" -gt "0" ];
    then
        curl -sLo /dev/null "http://$PRODUCT_SERVER_HOST:$PRODUCT_SERVER_PORT/ajax/sphinx/notif-rotate/main/${SERVERID}"
    fi
fi



