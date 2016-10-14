export node="$node"
export envROOT="/data"
export currentPath="$currentPath"
export shellPath="$currentPath/shell"
export containersPath="$currentPath/containers"
export dockerIP=`ifconfig docker0 | grep 'inet addr' | awk -F: '{ print $2 }' | awk -F\  '{ print $1 }'`
