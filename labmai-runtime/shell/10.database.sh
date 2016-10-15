#/bin/bash

checkInstall mysql mysql-client-core-5.6

`hasDocker0` || echo "安装数据库的操作依赖docker服务，请确认您的docker已经安装并正常启动"
`hasDocker0` && confirm "安装数据库" && {
    mkdir -p $envROOT/var/lib/mysql
    docker run --rm -v $envROOT/var/lib/mysql:/var/lib/mysql genee/mariadb install
}
