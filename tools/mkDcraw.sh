#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
TOOLLOC=$SCRIPTPATH/latest

rm $TOOLLOC/dcraw

mkdir $SCRIPTPATH/dcraw; cd dcraw
wget --show-progress https://www.cybercom.net/~dcoffin/dcraw/dcraw.c
gcc -o dcraw -O4 dcraw.c -lm -ljasper -ljpeg -llcms2

mv dcraw $TOOLLOC/dcraw
cd $SCRIPTPATH; rm -rf dcraw
