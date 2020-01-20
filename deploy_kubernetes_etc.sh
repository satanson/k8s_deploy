#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
${basedir}/deliver.sh hosts/k8s.list kubernetes_etc /opt/kubernetes/etc sudo kube 0750
${basedir}/deliver.sh hosts/k8s.list kubernetes_etc/cni_calico.conf /opt/kubernetes/cni/net.d/cni_calico.conf  sudo kube 0750
./doall.sh hosts/k8s.list "sudo chown -R kube:kube /opt/kubernetes/cni"
