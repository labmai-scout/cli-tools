#/bin/bash

`hasDocker0` && {
    confirm "初始化mall-vendor环境" && {
        createTable 'mall_vendor'
        tmpMPATH="$envROOT/gini-modules/mall-vendor"
        `hasDocker0` && {
            tmpDocker0IP=`getDocker0IP`
            sed -i "s/e0933e2cbc44ce1bc3dec13e0c285722/mall-vendor #/g" $tmpMPATH/raw/config/gapper.yml
            sed -i "s/d6bf74d82b7f1d60462cacd124a7b8c6/mall-vendor #/g" $tmpMPATH/raw/config/gapper.yml
            sed -i "s/e0933e2cbc44ce1bc3dec13e0c285722/mall-vendor #/g" $tmpMPATH/raw/config/mall.yml
            sed -i "s/d6bf74d82b7f1d60462cacd124a7b8c6/mall-vendor #/g" $tmpMPATH/raw/config/mall.yml
        }
    }
}
