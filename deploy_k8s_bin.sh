#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

goPath=$(go env GOPATH)
goOs=$(go env GOOS)
goHostArch=$(go env GOHOSTARCH)

test -n ${goPath} -a -n ${goOs} -a -n ${goHostArch}

binDir=${goPath}/src/github.com/kubernetes/kubernetes/_output/local/bin/${goOs}/${goHostArch}
mkdir -p kubernetes_bin
for bin in kube-apiserver kube-scheduler kube-controller-manager kubelet kube-proxy;do
  cp ${binDir}/${bin} kubernetes_bin/
done

${basedir}/deliver.sh ${hostList} kubernetes_bin /opt/kubernetes/bin sudo kube 0750

mkdir -p cni_bin
cp ${goPath}/src/github.com/containernetworking/plugins/bin/loopback cni_bin/
cp ${goPath}/src/github.com/projectcalico/cni-plugin/cmd/calico-ipam/calico-ipam cni_bin/
cp ${goPath}/src/github.com/projectcalico/cni-plugin/cmd/calico/calico cni_bin/
${basedir}/deliver.sh ${hostList} cni_bin /opt/kubernetes/cni/bin sudo kube 0750
./doall.sh ${hostList} "\
  sudo chown -R kube:kube /opt/kubernetes/cni; \
  sudo mkdir -p /opt/kubernetes/kubelet; \
  sudo mkdir -p /opt/kubernetes/run; \
  "
