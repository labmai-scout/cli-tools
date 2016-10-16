#/bin/bash

`hadDocker0` && {
    confirm "初始化tag-db环境" && {
        createTable 'tag_db'
        tmpMPATH="$envROOT/gini-modules/tag-db"
        `hasDocker0` && {
            tmpDocker0IP=`getDocker0IP`
            sed -i "s/username: username/username: genee/g" $tmpMPATH/raw/config/database.yml
            sed -i "s/password: password/password: 83719730/g" $tmpMPATH/raw/config/database.yml
        }
    }
}
