#/bin/bash

export node=$1
export currentPath=$PWD
export envROOT="/data"
export shellPath="$currentPath/shell"
export containersPath="$currentPath/containers"
export labmaiDomain="pihizi.com"
export gapperDomain="pihizi.com"

echo "- 请确保使用 sudo 权限执行该脚本"
echo "- 环境将被搭建在/data目录下，请确保目录存在且为空"

function replaceNow() {
    tmpDIR=$1
    `hasDocker0` && {
        tmpDocker0IP=`getDocker0IP`
        sed -i "s/mysql.docker.local/$tmpDocker0IP/g" `grep 'mysql.docker.local' -rl $tmpDIR`
        sed -i "s/{{{DOCKER0IP}}}/$tmpDocker0IP/g" `grep DOCKER0IP -rl $tmpDIR`
        sed -i "s/db.gapper.in/$tmpDocker0IP/g" `grep 'db.gapper.in' -rl $tmpDIR`
        sed -i "s/172.17.42.1/$tmpDocker0IP/g" `grep '172.17.42.1' -rl $tmpDIR`
        sed -i "s/172.17.0.1/$tmpDocker0IP/g" `grep '172.17.0.1' -rl $tmpDIR`
        sed -i "s/gapper.in/$gapperDomain/g" `grep 'gapper.in' -rl $tmpDIR`
        sed -i "s/rd.labmai.com/$tmpDocker0IP/g" `grep 'rd.labmai.com' -rl $tmpDIR`
    }
    sed -i "s/{{{LABMAIDOMAIN}}}/$labmaiDomain/g" `grep LABMAIDOMAIN -rl $tmpDIR`
    sed -i "s/{{{GAPPERDOMAIN}}}/$gapperDomain/g" `grep GAPPERDOMAIN -rl $tmpDIR`
    sed -i "s/{{{NODE}}}/$node/g" `grep NODE -rl $tmpDIR`
}

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

function createTable() {
    tmpDBName=$1
    `hasDocker0` && {
        tmpDocker0IP=`getDocker0IP`
        `mysql -ugenee -p83719730 -h$tmpDocker0IP -e "create database ${tmpDBName}"`
    }
}

`hasDocker0` || {
    confirm "安装docker" && {
        apt-get install -y apt-transport-https ca-certificates
        apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        tmpLSBReleaseV=`lsb_release -r | awk '{print $2}'`
        case $tmpLSBReleaseV in 
            "12.04")
                echo 'deb https://apt.dockerproject.org/repo ubuntu-precise main' > /etc/apt/sources.list.d/docker.list
                # TODO 不支持12.04
                ;;
            "14.04")
                echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list
                apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
                ;;
            "16.04")
                echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
                apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
                ;;
        esac
        apt-get update -y
        apt-get purge lxc-docker
        apt-cache policy docker-engine
        apt-get install -y docker-engine
        service docker start
        groupadd docker
        usermod -aG docker $SUDO_USER
        
        checkInstall pip python-pip
        pip install docker-compose
    }
}

confirm "继续" && {
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
