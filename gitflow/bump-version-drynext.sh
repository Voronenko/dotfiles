#!/bin/bash

# credits: http://stackoverflow.com/questions/8653126/how-to-increment-version-number-in-a-shell-script
# increments major version and zerorifies minor, i.e. 0.17.1 => 0.18.0

increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-2; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  part[2]=0 #zerorify minor version
  new="${part[*]}"
  echo -e "${new// /.}"
}

VERSION=`cat version.txt`

increment_version $VERSION
