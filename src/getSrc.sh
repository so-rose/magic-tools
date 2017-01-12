#!/bin/bash

repo="$1"
if [[ -z $repo ]]; then repo="https://bitbucket.org/hudson/magic-lantern"; fi
if [[ $repo == "default" ]]; then repo="https://bitbucket.org/hudson/magic-lantern"; fi
if [[ $repo == "danne" ]]; then repo="https://bitbucket.org/Dannephoto/magic-lantern"; fi

branch="$2"
if [[ -z $branch ]]; then branch="unified"; fi
if [[ $branch == "danne" ]]; then branch="ml-dng-unified_3"; fi

#Remove old src
rm -rf magic-lantern

#Get HG stuff from custom repo.
hg clone "$repo"
cd magic-lantern
hg pull && hg update "$branch"

