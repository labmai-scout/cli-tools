#/bin/bash

`hasDocker0` && {
    confirm "初始化mall-hub-product环境" && {
        createTable 'mall_hub_product'
        tmpMPATH="$envROOT/gini-modules/mall-hub-product"
        `hasDocker0` && {
            tmpDocker0IP=`getDocker0IP`
            sed -i "s/sphinxsearch.docker.local/$tmpDocker0IP/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/host=mysql/host=$tmpDocker0IP/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/CLIENTID/mall-hub-product/g" $tmpMPATH/raw/config/gapper.yml
            sed -i "s/CLIENTSECRET/mall-hub-product/g" $tmpMPATH/raw/config/gapper.yml
        }
    }
}
