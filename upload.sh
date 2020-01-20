#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"undefined 'hostList'"};shift
script=${1:?"undefined 'script'"};shift
scriptname=$(basename ${script})
source ${basedir}/functions.sh
for rs in $(ipList ${hostList}); do
 scp  -i ${basedir}/id_rsa_vagrant ${script} vagrant@${rs}:/tmp/${scriptname}
done
