#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
goPath=$(go env GOPATH)
goOs=$(go env GOOS)
goHostArch=$(go env GOHOSTARCH)

test -n ${goPath} -a -n ${goOs} -a -n ${goHostArch}

binDir=${goPath}/src/github.com/kubernetes/kubernetes/_output/local/bin/${goOs}/${goHostArch}
mkdir -p kubernetes_bin
for bin in kube-apiserver kube-scheduler kube-controller-manager kubelet kube-proxy;do
  cp ${binDir}/${bin} kubernetes_bin/
done

${basedir}/deliver.sh hosts/k8s.list kubernetes_bin /opt/kubernetes/bin sudo kube 0550

mkdir -p cni_bin
cp ${goPath}/src/github.com/containernetworking/plugins/bin/loopback cni_bin/
cp ${goPath}/src/github.com/projectcalico/cni-plugin/cmd/calico-ipam/calico-ipam cni_bin/
cp ${goPath}/src/github.com/projectcalico/cni-plugin/cmd/calico/calico cni_bin/
${basedir}/deliver.sh hosts/k8s.list cni_bin /opt/kubernetes/cni/bin sudo kube 0550
./doall.sh hosts/k8s.list "sudo chown -R kube:kube /opt/kubernetes/cni"
