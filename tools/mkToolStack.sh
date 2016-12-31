#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
ML_PATH="${SCRIPTPATH}/../src/magic-lantern"

TOOLLOC=$SCRIPTPATH/latest

rm -rf $SCRIPTPATH/old
mv $TOOLLOC $SCRIPTPATH/old
mkdir $TOOLLOC

#Prepare source.
cd $ML_PATH
patch < ../patches/* #Apply patches.

#Compile mlv_dump.
cd $ML_PATH/modules/mlv_rec

make clean; make mlv_dump -j

cp mlv_dump $TOOLLOC

make clean

#Compile cr2hdr.
cd $ML_PATH/modules/dual_iso

make clean; make cr2hdr -j

cp cr2hdr $TOOLLOC

make clean

#Compile raw2dng.
cd $ML_PATH/modules/raw_rec

make clean; make raw2dng -j

cp raw2dng $TOOLLOC

make clean

#Make dcraw. Because why not.
$SCRIPTPATH/mkDcraw.sh

#Make Executable
chmod -R +x $TOOLLOC/*

#Cleanup
cd $ML_PATH
patch -R < ../patches/* #Remove patches.
