#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

cat >scripts/teardown_k8s.sh <<'DONE'
#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

systemctl stop kube-proxy kubelet kube-controller-manager kube-scheduler kube-apiserver 
docker kill calico-node
docker rm calico-node
for c in $(docker ps -a |perl -lne 'print $1 if /^(\w+).*k8s_POD/');do
  docker kill $c
  docker rm $c
done

for d in $(mount -l |perl -lne 'print $1 if m{^tmpfs on (/opt/kubernetes/kubelet/pods\S+)\s*}');do
  umount "${d}"
done

[ -d /opt/kubernetes/kubelet ] && rm -fr /opt/kubernetes/kubelet
[ -d /opt/kubernetes/run ] && rm -fr /opt/kubernetes/run
[ -d /opt/kubernetes/logs ] && rm -fr /opt/kubernetes/logs
DONE

./upload.sh ${hostList} scripts/teardown_k8s.sh
./doall.sh ${hostList} "chmod a+x /tmp/teardown_k8s.sh; sudo /tmp/teardown_k8s.sh"

./etcdctl.sh del /calico/a /calico/z
./etcdctl.sh del /registry/a /registry/z
