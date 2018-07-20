#!/bin/bash

me=$(basename "$0")
me="crouton-buddy/$me"

execDir=`pwd`
cd $(dirname "$0")
bin=`pwd`
cd "$execDir"


. cb-base.sh
cbRun

exit 0
