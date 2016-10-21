#/bin/bash

apt-get update -y
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
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update -y
apt-get purge lxc-docker
apt-cache policy docker-engine
apt-get install -y docker-engine
service docker start
# groupadd docker
# usermod -aG docker $SUDO_USER

checkInstall pip python-pip
pip install docker-compose
