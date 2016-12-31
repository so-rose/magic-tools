#!/bin/bash

#Get HG stuff.
hg clone https://bitbucket.org/hudson/magic-lantern
cd magic-lantern
hg checkout unified
hg pull
