#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

${basedir}/deliver.sh ${hostList} kubernetes_etc /opt/kubernetes/etc sudo kube 0750
${basedir}/deliver.sh ${hostList} kubernetes_etc/cni_calico.conf /opt/kubernetes/cni/net.d/cni_calico.conf  sudo kube 0750
./doall.sh ${hostList} "sudo chown -R kube:kube /opt/kubernetes/cni"
