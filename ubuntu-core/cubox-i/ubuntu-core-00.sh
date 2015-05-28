#!/bin/sh

dev=sdb
curl -sSL https://www.dropbox.com/s/jehuqgwfv0iaisp/SPL?dl=0 | sudo dd of=/dev/$dev bs=1k seek=1
curl -sSL https://www.dropbox.com/s/qtlqh7m6d4dkn76/u-boot.img?dl=0 | sudo dd of=/dev/$dev bs=1k seek=42
sync
echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk /dev/sdb
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs /dev/${dev}1
sudo mount /dev/${dev}1 ./rootfs
