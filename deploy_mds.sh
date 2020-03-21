#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

${basedir}/deliver.sh hosts/k8s.list ceph_conf /etc/ceph sudo root 0755

cat >scripts/deploy_mds.sh <<'DONE'
#!/bin/bash

id=$(hostname -s)
systemctl daemon-reload

set +e +o pipefail
systemctl stop ceph-mds.target
systemctl stop ceph-mds@.service
systemctl stop ceph-mds@${id}

systemctl disable  ceph-mds.target
systemctl disable  ceph-mds@.service
systemctl disable  ceph-mds@${id}
set -e -o pipefail

systemctl enable ceph-mds.target
systemctl enable ceph-mds@${id}

/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_mds.sh

systemctl start ceph-mds.target
systemctl restart ceph-mds.target
systemctl status ceph-mds@${id}
DONE

./upload.sh hosts/k8s.list scripts/deploy_mds.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_mds.sh && sudo ./deploy_mds.sh"
