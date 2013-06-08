#!/bin/sh
##
## zImage to boot.img test script...
##

## delete *.ko files
rm ./ramdisk/lib/modules/*

tar zxvf ./ramdisk.tgz ./
# copy *.ko file to <ramdisk>/lib/modules
find -name '*.ko' ! -path "./ramdisk*" -exec cp -av {} ./ramdisk/lib/modules \;

# copy prima_wlan_ko to prima_wlan.ko
#cp -av ./ramdisk/vendor/bcmdhd.ko ./ramdisk/lib/modules/bcmdhd.ko

# ramdisk copy to tmp dir
mkdir tmp
cp -pr ./ramdisk ./tmp/ramdisk
# rm .gitignore
find ./tmp/ramdisk -name '*.gitignore' -print | xargs rm
chmod 750 ./tmp/ramdisk/init.*

# create boot image >> output dir
./build-tools/repack-bootimg.pl arch/arm/boot/zImage ./tmp/ramdisk ./output/boot`date +%m%d`-`cat .version`.img

# delete tmp dir
rm -r ./tmp/ramdisk ./tmp
echo "output to ./output/boot`date +%m%d`-`cat .version`.img"
