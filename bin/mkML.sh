#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
ML_PATH="${SCRIPTPATH}/../src/magic-lantern/platform/7D.203"

rm -rf $SCRIPTPATH/stable
mv $SCRIPTPATH/latest $SCRIPTPATH/stable

cd $ML_PATH

#Prepare source.
cd $ML_PATH/../..
patch < ../patches/* #Apply patches.
make clean 
cd $ML_PATH

#Do the compile.
make clean; make -j; make zip

files=( "*.zip" )
echo "Built ${files[0]}."
unzip "${files[0]}" -d build #unzip the created zip file into "build".

cp -r build $SCRIPTPATH/latest
rm -rf build

#Cleanup
cd $ML_PATH/../..
patch -R < ../patches/* #Remove patches.
