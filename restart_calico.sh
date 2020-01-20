#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

${basedir}/etcdctl.sh del /calico/a /calico/z
./doall.sh hosts/k8s.list "sudo docker kill calico-node"
./upload.sh hosts/k8s.list calicoctl.sh

cat >scripts/reset_calico_node.sh  <<'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
cp /tmp/calicoctl.sh /bin/
chmod a+x /bin/calicoctl.sh
calicoctl.sh node run --no-default-ippools
DONE

./upload.sh hosts/k8s.list scripts/reset_calico_node.sh
./doall.sh hosts/k8s.list "chmod a+x /tmp/reset_calico_node.sh;sudo /tmp/reset_calico_node.sh"
