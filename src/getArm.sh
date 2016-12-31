#!/bin/bash

#Assumes gcc 5.4.X !!

pkgName=gcc-arm-none-eabi-5_4-2016q3 #Get from launchpas version

if [[ -d ~/${pkgName} ]]; then echo "Found ARM. Not downloading new one."; exit 0; fi

wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2 -O ~/${pkgName}.tar.bz2

mkdir -p ~/${pkgName}
tar -C ~/${pkgName} -xvjf ~/${pkgName}.tar.bz2
rm ~/${pkgName}.tar.bz2

echo -e "\nMake sure to check patches/armpath.patch!"
