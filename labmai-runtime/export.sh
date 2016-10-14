export node=$1
export envROOT="/data"
export currentPath=$PWD
export shellPath="$currentPath/shell"
export containersPath="$currentPath/containers"
export dockerIP=`ifconfig docker0 | grep 'inet addr' | awk -F: '{ print $2 }' | awk -F\  '{ print $1 }'`
