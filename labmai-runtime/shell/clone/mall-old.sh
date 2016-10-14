#/bin/bash

confirm "初始化mall-old环境" && {
    tmpDiskD="$envROOT/mall-disk/$node"
    tmpGP="$envROOT/mall-old"
    mkdir -p $tmpDiskD
    `chown -R www-data:www-data $tmpDiskD`
    #cd $tmpGP && git checkout mall-vendor && git submodule init && git submodule update && cd -
    cd $tmpGP && git submodule init && git submodule update && cd -

    sed -i "s/\"authors\"/\"config\":{\"secure-http\": false},\"authors\"/g" $tmpGP/composer.json
    sed -i "s/genee-redis.docker.local/$dockerIP/g" $tmpGP/cli/base.php
    sed -i "s/^date_default_timezone_set/define('REDIS_HOST', '$dockerIP');date_default_timezone_set/g" $tmpGP/public/index.php
    mkdir -p "$tmpGP/sites/$node/logs"
    `touch "$tmpGP/sites/$node/logs/journal.log"`
    `touch "$tmpGP/sites/$node/logs/logon.log"`
    `touch "$tmpGP/sites/$node/logs/mail.log"`
    `touch "$tmpGP/sites/$node/logs/vendor.log"`
    mkdir -p "$tmpGP/sites/$node/private/order_voucher"
    mkdir -p "$tmpGP/sites/$node/private/payment_voucher"
    mkdir -p "$tmpGP/public/cache"
    `chown -R www-data:www-data "$tmpGP/sites/$node/logs"`
    `chown -R www-data:www-data "$tmpGP/sites/$node/private"`
    `chown -R www-data:www-data "$tmpGP/public/cache"`

    confirm "初始化mall-old的数据库" && {
        tmpDBNames=("mall_NODE")
        for tmpDBName in $tmpDBNames
        do
            tmpDBName=`echo $tmpDBName | sed -e "s/NODE/$node/g"`
            `mysql -ugenee -p83719730 -h$dockerIP -e "create database ${tmpDBName}"`
        done
    }

    confirm "初始化mall-old代码依赖" && {
        docker exec -t mall-old sh -lc "cd /data/mall-old && composer update --prefer-dist"
        docker exec -t mall-old sh -lc "cd /data/mall-old/cli && SITE_ID=$node php create_orm_tables.php"
        docker exec -it mall-old sh -lc "cd /data/mall-old/cli && SITE_ID=$node php add_user.php genee"
    }
}
