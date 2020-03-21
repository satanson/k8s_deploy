#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

${basedir}/deliver.sh hosts/k8s.list ceph_conf /etc/ceph sudo root 0755

cat >scripts/deploy_mgr.sh <<'DONE'
#!/bin/bash

id=$(hostname -s)
systemctl daemon-reload

set +e +o pipefail
systemctl stop ceph-mgr.target
systemctl stop ceph-mgr@.service
systemctl stop ceph-mgr@${id}

systemctl disable  ceph-mgr.target
systemctl disable  ceph-mgr@.service
systemctl disable  ceph-mgr@${id}
set -e -o pipefail

systemctl enable ceph-mgr.target
systemctl enable ceph-mgr@${id}

/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_mgr.sh

systemctl start ceph-mgr.target
systemctl restart ceph-mgr.target
systemctl status ceph-mgr@${id}
echo ok
DONE

./upload.sh hosts/k8s.list scripts/deploy_mgr.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_mgr.sh && sudo ./deploy_mgr.sh"
