#/bin/bash

`hasDocker0` && {
    confirm "初始化gapper-server环境" && {
        createTable 'gapper'
    }
}
