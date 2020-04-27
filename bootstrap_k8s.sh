#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift
./reset_k8s.sh ${hostList} deploy
