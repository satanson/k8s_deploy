#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

tar czvf ceph_scripts.tgz ceph_scripts
tar czvf ceph_conf.tgz ceph_conf

./upload.sh hosts/k8s.list ceph_scripts.tgz
./upload.sh hosts/k8s.list ceph_conf.tgz

cat >scripts/deploy_mgr.sh <<'DONE'
#!/bin/bash

ls -d  /etc/systemd/system/ceph-mgr*

set -e -o pipefail

test -f /tmp/ceph_conf.tgz
test -f /tmp/ceph_scripts.tgz

pushd /opt
[ -d ceph_scripts.bak ] && rm -fr ceph_scripts.bak
[ -d ceph_scripts ] && mv ceph_scripts ceph_scripts.bak
tar xzvf /tmp/ceph_scripts.tgz
popd

pushd /etc
[ -d ceph.bak ] && rm -fr ceph.bak
[ -d ceph ] && mv ceph ceph.bak
tar xzvf /tmp/ceph_conf.tgz
mv ceph_conf ceph
popd


id=$(hostname -s)
systemctl daemon-reload

set +e +o pipefail
systemctl stop ceph-mgr.target
systemctl stop ceph-mgr@.service
systemctl stop  ceph-mgr@${id}

systemctl disable  ceph-mgr.target
systemctl disable  ceph-mgr@.service
systemctl disable  ceph-mgr@${id}
set -e -o pipefail

systemctl enable /opt/ceph_scripts/ceph-mgr.target
systemctl enable /opt/ceph_scripts/ceph-mgr@.service
systemctl enable ceph-mgr@${id}

/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_mgr.sh

systemctl start ceph-mgr@${id}
systemctl restart ceph-mgr@${id}
systemctl status ceph-mgr@${id}
DONE

./upload.sh hosts/k8s.list scripts/deploy_mgr.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_mgr.sh && sudo ./deploy_mgr.sh"
