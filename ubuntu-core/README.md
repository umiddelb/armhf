# Zero to Docker within 5 minutes

This directory tree contains a collection of scripts helping you to set up Ubuntu Core 14.04.2 and Docker 
on your ARMv7 device within less then five minutes. Each subdirectory has this collection of scripts: 

- ubuntu-core-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- ubuntu-core-01.sh: unpacks the Ubuntu Core userland, prepare and jump into the chroot environment
- ubuntu-core-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc4.9, install the kernel image 
- ubuntu-docker-00.sh: setup docker in the newly booted environment (doesn't work in chroot)

You will find a step by step description [here](http://forum.odroid.com/viewtopic.php?p=91036#p91036)
