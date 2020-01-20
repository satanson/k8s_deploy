#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"undefined 'hostList'"};shift
script=${1:?"undefined 'script'"}

scriptname=$(basename ${script})
${basedir}/upload.sh ${hostList} ${script}
${basedir}/doall_oneline.sh ${hostList} chmod a+x /tmp/${scriptname}
${basedir}/doall_oneline.sh ${hostList} /tmp/${scriptname}
