#!/bin/sh

locale-gen en_GB.UTF-8
locale-gen de_DE.UTF-8
update-locale LANG=en_GB.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
echo "Europe/Berlin" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo armv7 > /etc/hostname
echo "127.0.0.1       armv7 localhost" >> /etc/hosts
echo "deb http://ports.ubuntu.com/ trusty main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "nameserver 8.8.8.8" > /etc/resolv.conf

dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install software-properties-common u-boot-tools isc-dhcp-client ubuntu-minimal ssh
apt-get -y install cifs-utils screen wireless-tools iw curl libncurses5-dev cpufrequtils rcs aptitude make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils linux-firmware linux-firmware-nonfree

apt-get -y install python-software-properties
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt-get -y install gcc

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
apt-get update
mkdir -p /media/boot
apt-get -y install linux-image-c1 bootini
cp boot/uInitrd-3.10.* /media/boot/uInitrd 
cp boot/uImage-3.10.* /media/boot/uImage  

echo "auto lo" > /etc/network/interfaces.d/lo
echo "iface lo inet loopback" >> /etc/network/interfaces.d/lo
echo "auto eth0" >/etc/network/interfaces.d/eth0
echo "iface eth0 inet dhcp" >>/etc/network/interfaces.d/eth0
echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/ttyS0.conf
echo "stop on runlevel [!12345]" >> /etc/init/ttyS0.conf
echo "respawn" >> /etc/init/ttyS0.conf
echo "exec /sbin/getty -L 115200 ttyS0 vt102" >> /etc/init/ttyS0.conf

adduser ubuntu
usermod -aG adm,cdrom,sudo,plugdev ubuntu

apt-get clean
rm /sbin/initctl
dpkg-divert --local --rename --remove /sbin/initctl
