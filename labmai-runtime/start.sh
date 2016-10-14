#/bin/bash

echo "\n\n"
echo "环境将被搭建在/data目录下，请确保目录存在且为空"
echo "\n\n"

export node=$1
export currentPath=$PWD
source export.sh

if [ "$node" == "" ];
then
    echo "请输入你希望操作的node，如node: $0 node"
    exit
fi

function confirm() {
    source $currentPath/export.sh
    echo "$1 (Y/n): "
    read $tmpNeed
    if [ "$tmpNeed" == "n" ];
    then
        return 1
    fi
    return 0
}

shellFiles=`ls -v $shellPath`
for shellFile in $shellFiles
do
    if [[ $shellFile == *\.sh ]]
    then
        source $shellPath/$shellFile
    fi
done

