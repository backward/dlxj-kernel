#!/usr/bin/perl -W

use strict;
use Cwd;


my $dir = getcwd;

my $usage = "repack-bootimg.pl <kernel> <ramdisk-directory> <outfile>\n";

die $usage unless $ARGV[0] && $ARGV[1] && $ARGV[2];

chdir $ARGV[1] or die "$ARGV[1] $!";

system ("find . | cpio -o -H newc | gzip -9 > $dir/ramdisk-repack.cpio.gz");

chdir $dir or die "$ARGV[1] $!";;

system ("./build-tools/mkbootimg --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=dlxj user_debug=31' --kernel $ARGV[0] --ramdisk ramdisk-repack.cpio.gz --base 0x80600000 --ramdiskaddr 0x81a08000 -o $ARGV[2]");

unlink("ramdisk-repack.cpio.gz") or die $!;

print "\nrepacked boot image written at $ARGV[1]-repack.img\n";
