#/bin/bash

command -v mysql >/dev/null 2>&1
tmpResult=$?
if [ "$tmpResult" != "0" ];
then
    sudo apt-get install -y mysql-client-core-5.6
fi

confirm "安装数据库" && {
    mkdir -p $envRoot/var/lib/mysql
    docker run --rm -v $envRoot/var/lib/mysql:/var/lib/mysql genee/mariadb install
}
