#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
${basedir}/deliver.sh hosts/k8s.list kubernetes_scripts /opt/kubernetes/scripts sudo kube 0750
