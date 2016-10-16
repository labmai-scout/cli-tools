#/bin/bash

`hasDocker0` && {
    confirm "初始化mall-hub-node环境" && {
        createTable 'mall_hub_node'
        tmpMPATH="$envROOT/gini-modules/mall-hub-node"
        `hasDocker0` && {
            tmpDocker0IP=`getDocker0IP`
            sed -i "s/HOST/$tmpDocker0IP/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/username: USERNAME/username: genee/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/password: PASSWORD/password: 83719730/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/client_id: client_id/client_id: mall_hub_node/g" $tmpMPATH/raw/config/gapper.yml
            sed -i "s/client_secret: client_secret/client_secret: mall_hub_node/g" $tmpMPATH/raw/config/gapper.yml
        }
    }
}
