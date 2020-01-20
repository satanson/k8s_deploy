#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

cat <<'DONE' | sudo bash -
#!/bin/bash
set -e -o pipefail
[ -d /etc/ceph.bck ] && rm -fr /etc/ceph.bak
[ -d /etc/ceph ] && mv /etc/ceph /etc/ceph.bak
cp -r ceph_conf /etc/ceph
/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_mon.sh
[ -d ceph_conf ] && rm -r ceph_conf
cp -r /etc/ceph ceph_conf
chown -R ${USER}:${USER} ceph_conf
DONE

tar czvf ceph_scripts.tgz ceph_scripts
tar czvf ceph_conf.tgz ceph_conf

./upload.sh hosts/k8s.list ceph_scripts.tgz
./upload.sh hosts/k8s.list ceph_conf.tgz

cat >scripts/deploy_mon.sh <<'DONE'
#!/bin/bash

id=$(hostname -s)
set -x
systemctl stop ceph-osd.target
systemctl stop ceph-mgr.target
systemctl stop ceph-mon.target
systemctl disable ceph-mon.target
systemctl disable ceph-mgr.target
systemctl disable ceph-osd.target
systemctl disable ceph-mon@.service
systemctl disable ceph-mgr@.service
systemctl disable ceph-osd@.service
systemctl disable ceph-mon@${id}
systemctl disable ceph-mgr@${id}
[ -d /var/lib/ceph ] && rm -fr /var/lib/ceph
[ -d /var/log/ceph ] && rm -fr /var/log/ceph

rm -fr /etc/systemd/system/ceph-mon*
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

mkdir -p /var/lib/ceph
mkdir -p /var/run/ceph
mkdir -p /var/log/ceph

systemctl daemon-reload
systemctl enable /opt/ceph_scripts/ceph-mon.target
systemctl enable /opt/ceph_scripts/ceph-mon@.service
systemctl enable ceph-mon@${id}

/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/mkfs_ceph_mon.sh

systemctl start ceph-mon@${id}
systemctl restart ceph-mon@${id}
systemctl status ceph-mon@${id}
DONE

./upload.sh hosts/k8s.list scripts/deploy_mon.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_mon.sh && sudo ./deploy_mon.sh"
