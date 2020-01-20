#!/bin/bash

set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift
user=${1:?"missing 'user'"};shift
./upload.sh ${hostList} add_user.sh
./doall.sh ${hostList} "chmod a+x /tmp/add_user.sh; sudo /tmp/add_user.sh ${user}"
