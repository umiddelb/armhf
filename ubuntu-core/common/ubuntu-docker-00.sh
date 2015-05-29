#!/bin/sh

sudo apt-get -y install lxc aufs-tools cgroup-lite apparmor docker.io
sudo service docker.io stop
sudo curl -sSL https://github.com/umiddelb/armhf/blob/master/bin/docker-1.6.0?raw=true >/usr/bin/docker
sudo service docker.io start
sudo usermod -aG docker $SUDO_USER
