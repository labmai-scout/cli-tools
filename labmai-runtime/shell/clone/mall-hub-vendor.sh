#/bin/bash

`hadDocker0` && {
    confirm "初始化mall-hub-vendor环境" && {
        createTable 'mall_hub_vendor'
        tmpMPATH="$envROOT/gini-modules/mall-hub-vendor"
        `hasDocker0` && {
            tmpDocker0IP=`getDocker0IP`
            sed -i "s/host=mysql/host=$tmpDocker0IP/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/CLIENTID/mall-hub-vendor/g" $tmpMPATH/raw/config/gapper.yml
            sed -i "s/CLIENTSECRET/mall-hub-vendor/g" $tmpMPATH/raw/config/gapper.yml
        }
    }
}
