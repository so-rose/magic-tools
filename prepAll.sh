#!/bin/bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

#Compile exfat_sum.
cd ${SCRIPTPATH}/prep_card
gcc exfat_sum.c -o exfat_sum

#Get Magic Lantern source
cd ${SCRIPTPATH}/src
./getSrc.sh

#All Done!
