#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

${basedir}/deliver.sh ${hostList} kubernetes_systemd /opt/kubernetes/systemd sudo kube 0750
${basedir}/doall.sh ${hostList} "sudo systemctl daemon-reload;\
  sudo  find /opt/kubernetes/systemd -name '*.service' -type f | \
  xargs -i{} sudo systemctl enable '{}'"
