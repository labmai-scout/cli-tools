#/bin/bash

`hasDocker0` && {
    confirm "启动docker containers" && {
        tmpContainersPath="$envROOT/containers"
        if [ -d $tmpContainersPath ];
        then
            rm -rf $tmpContainersPath
        fi

        tmpCCP="$shellPath/docker-compose/containers"

        cp -R $tmpCCP $tmpContainersPath
        mkdir -p $envROOT/var/lib/redis
        mkdir -p $envROOT/var/log/nginx
        mkdir -p $envROOT/var/lib/sphinxsearch/data/mall_hub
        mkdir -p $envROOT/var/log/sphinxsearch

        `replaceNow $tmpContainersPath`

        tmpOPWD=$pwd
        cd $tmpContainersPath
        source ./restart.sh
        cd $tmpOPWD
    }
}
