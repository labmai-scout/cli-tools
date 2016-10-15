#/bin/bash

function confirm() {
    echo "$1 (Y/n): "
    read tmpNeed
    if [ "$tmpNeed" == "n" ];
    then
        return -1
    fi
    return 0
}

checkInstallPID="NONE"
PID=$$
function checkInstall() {
    command -v $1 >/dev/null 2>&1
    tmpResult=$?
    tmpPKG=$2
    if [ "$tmpPKG" == "" ];
    then
        tmpPKG=$1
    fi
    if [ "$tmpResult" != "0" ];
    then
        if [ "$checkInstallPID" != "$PID" ];
        then
            checkInstallPID=$PID
            apt-get update -y
        fi
        echo "Install ${tmpPKG}..."
        apt-get install -y $tmpPKG
    fi
}

function hasDocker0() {
    `ifconfig docker0 >/dev/null 2>&1`
    tmpHasDocker0=$?
    if [ "$tmpHasDocker0" != "0" ];
    then
        return -1
    fi
    return 0
}

function getDocker0IP() {
    tmpDockerIP=`ifconfig docker0 | grep 'inet addr' | awk -F: '{ print $2 }' | awk -F\  '{ print $1 }'`
    echo $tmpDockerIP
}

echo "- 请确保使用 sudo 权限执行该脚本"
echo "- 环境将被搭建在/data目录下，请确保目录存在且为空"

confirm "继续" && {
    export node=$1
    export currentPath=$PWD
    export envROOT="/data"
    export shellPath="$currentPath/shell"
    export containersPath="$currentPath/containers"
    export labmaiDomain="pihizi.com"
    export gapperDomain="pihizi.com"

    if [ "$node" == "" ];
    then
        echo "请输入你希望操作的node，如node: $0 node"
        exit
    fi

    shellFiles=`ls -v $shellPath`
    for shellFile in $shellFiles
    do
        if [[ $shellFile == *\.sh ]]
        then
            source $shellPath/$shellFile
        fi
    done
}
