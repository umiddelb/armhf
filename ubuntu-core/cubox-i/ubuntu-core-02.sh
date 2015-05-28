#!/bin/sh

locale-gen en_GB.UTF-8
locale-gen de_DE.UTF-8
export LC_ALL="en_GB.UTF-8"
update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 LC_MESSAGES=POSIX
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

curl -sSL https://www.dropbox.com/s/revs8eyumpzb8z8/linux-imx-3.14.29%2B.tbz?dl=0 | tar -C / --numeric-owner -xjpvf -
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx-4.0.4-Modules.tar.gz | tar --numeric-owner -xzpvf -
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx-4.0.4-System.map > /boot/System.map
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx-4.0.4-zImage > /boot/zImage
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx-4.0.4.config > /boot/config
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx6dl-cubox-i-4.0.4.dtb > /boot/imx6dl-cubox-i.dtb
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx6dl-hummingboard-4.0.4.dtb > /boot/imx6dl-hummingboard.dtb
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx6q-cubox-i-4.0.4.dtb > /boot/imx6q-cubox-i.dtb
#curl -sSL http://www.xilka.com/kernel/4/4.0/4.0.4/release/1/imx6q-hummingboard-4.0.4.dtb > /boot/imx6q-hummingboard.dtb 

echo "auto lo" > /etc/network/interfaces.d/lo
echo "iface lo inet loopback" >> /etc/network/interfaces.d/lo
echo "auto eth0" >/etc/network/interfaces.d/eth0
echo "iface eth0 inet dhcp" >>/etc/network/interfaces.d/eth0
echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/ttymxc0.conf
echo "stop on runlevel [!12345]" >> /etc/init/ttymxc0.conf
echo "respawn" >> /etc/init/ttymxc0.conf
echo "exec /sbin/getty -L 115200 ttymxc0 vt102" >> /etc/init/ttymxc0.conf

adduser --gecos '' ubuntu
usermod -aG adm,cdrom,sudo,plugdev ubuntu

apt-get clean
rm /sbin/initctl
dpkg-divert --local --rename --remove /sbin/initctl
