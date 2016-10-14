#/bin/bash

confirm "替换{{{DOCKER0IP}}}和{{{NODE}}}" && {
    if [ "$dockerIP" == "" ];
    then
        echo "获取docker0的IP失败"
    else
        tmpContainersPath="$envRoot/containers"
        if [ -d $tmpContainersPath ];
        then
            rm -rf $tmpContainersPath
        fi

        tmpCCP="$shellPath/docker-compose/containers"

        cp -R $tmpCCP $tmpContainersPath
        mkdir -p $envROOT/var/lib/redis
        mkdir -p $envROOT/var/log/nginx

        sed -i "s/{{{DOCKER0IP}}}/$dockerIP/g" `grep DOCKER0IP -rl $tmpContainersPath`
        sed -i "s/{{{NODE}}}/$node/g" `grep NODE -rl $tmpContainersPath`
    fi
}
