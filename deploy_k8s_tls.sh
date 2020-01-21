#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

${basedir}/deliver.sh ${hostList} kubernetes_tls /opt/kubernetes/tls sudo kube 0750
