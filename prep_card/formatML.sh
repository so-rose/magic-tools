#!/bin/bash

#Run with sudo. Always.
#To use compile, you must have setup the source code to be able to compile with make already!

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

#Valid options: src, bin.
ML="bin"
ML_PATH="" #Means different things based on the value of ML.
SD_NAME="EOS_DIGITAL"

help() {
less -R << EOF 
Usage:
	$(echo -e "\033[1m./formatML.sh\033[0m -r <path> [OPTIONS] /dev/sd<??>")

PATTERN GUIDELINES:
	Format a Magic Lantern flashcard, potentially compiling Magic Lantern to do so.
	
	You must place make_bootable.sh and exfat_sum in the same directory.
	
	Download the "cleaned" source code: https://groups.google.com/forum/#!topic/ml-devel/EWHU5ukyMt4 .
		*Compile exfat_sum with 'gcc exfat_sum.c -o exfat_sum'.
		
	To do an auto source compile, it must already be setup to compile correctly with make (the compiler toolchain must be working correctly).

	Ex. sudo ./formatML.sh -p ~/magic-lantern/bin/latest /dev/sdc1
	Ex. sudo ./formatML.sh -m src -p ~/subhome/src/magic-lantern/platform/7D.203 /dev/sdc1

OPTIONS:
	-m		ml_src - Where to get ML from. 'src' will compile a nightly build. 'bin' will copy prebuilt files over.
				*bin is default.
	-p		path - If compiling, path to the platform in the source. If using binary, path to the ML build.
				*Defaults to nothing - must be specified.
	-n		name - The name of the prepared SD card. Must match length of EOS_DIGITAL

EOF
}

while getopts "vh m: p: n:" opt; do
	case "$opt" in
		h)
			help
			exit 0
			;;		
		
		v)
			echo -e "See formatML.sh -h"
			exit 0
			;;
		m)
			ML=${OPTARG}
			;;
		p)
			ML_PATH=$(readlink -f ${OPTARG})
			if [[ ! -d $ML_PATH ]]; then
				echo "Source path does not exist!"
			fi
			;;
		n)
			SD_NAME=${OPTARG}
			;;
		*)
			echo "Invalid option: -$OPTARG" >&2
			;;
	esac
done

shift $((OPTIND-1))
SD_LOC=$1

if [ -z $SD_LOC ]; then echo "Not a valid device!"; exit 1; fi
if [ -z $ML_PATH ]; then echo "Not a valid path!"; exit 1; fi

#Run some checks. These are dangerous operations :).

#Format filesystem.
umount "$SD_LOC" 2>/dev/null
mkdosfs -F 32 -I "$SD_LOC"

copyML() {
	ML_BIN="$1"
	MOUNTPOINT="/media/$(logname)/$SD_NAME"
	
	mount "$SD_LOC" $MOUNTPOINT
	cp -r $ML_BIN/* $MOUNTPOINT
	sleep 0.5
	umount "$SD_LOC"
	sleep 0.5
}

#Potentially compile & copy files over.
if [[ $ML == "src" ]]; then
	#Prepare source.
	cd $ML_PATH/../..
	patch < ../patches/* #Apply patches.
	
	cd $ML_PATH
	
	#Have to build ML as the user who is sudoing in.
	su $(logname) -c "make clean; make -j; make zip"
	
	files=( "*.zip" )
	echo "Built ${files[0]}."
	unzip "${files[0]}" -d build #unzip the created zip file into "build".
	
	copyML "$(pwd)/build"
	
	#Cleanup
	rm -rf build
	su $(logname) -c "make clean"
	
	#Clean Patches
	cd $ML_PATH/../..
	patch -R < ../patches/* #Remove patches.
	
	cd $SCRIPTPATH
elif [[ $ML == "bin" ]]; then
	copyML "$ML_PATH"
fi

#Make bootable with make_bootable.sh & eject.
$SCRIPTPATH/make_bootable.sh "$SD_LOC" $SD_NAME
#~ python3 "$SD_LOC" "$SD_NAME"
eject "$SD_LOC"

echo -e "\nFinished treating card! You can safely eject now."
