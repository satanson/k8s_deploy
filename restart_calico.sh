#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

${basedir}/etcdctl.sh del /calico/a /calico/z
./doall.sh ${hostList} "sudo docker kill calico-node"
./upload.sh ${hostList} calicoctl.sh

cat >scripts/reset_calico_node.sh  <<'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
cp /tmp/calicoctl.sh /bin/
chmod a+x /bin/calicoctl.sh
calicoctl.sh node run --no-default-ippools
DONE

./upload.sh ${hostList} scripts/reset_calico_node.sh
./doall.sh ${hostList} "chmod a+x /tmp/reset_calico_node.sh;sudo /tmp/reset_calico_node.sh"
./calicoctl.sh apply -f default-ipv4-ippool.yaml
