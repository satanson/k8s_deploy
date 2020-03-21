#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

cat >scripts/shutdown_ceph.sh <<'DONE'
#!/bin/bash

id=$(hostname -s)
set -x
for serv in {mds,mon,mgr};do
  systemctl stop ceph-${serv}.target
  systemctl disable ceph-${serv}.target
  systemctl stop ceph-${serv}@${id}
  systemctl disable ceph-${serv}@${id}
done

systemctl stop ceph-osd.target
systemctl disable ceph-osd.target
for id in $(ls /var/lib/ceph|perl -lne 'print $1 if /^osd-(\d+)$/');do
  systemctl stop ceph-osd@${id}
  systemctl disable ceph-osd@${id}
done
DONE

./upload.sh hosts/k8s.list scripts/shutdown_ceph.sh
./doall.sh hosts/k8s.list "chmod a+x shutdown_ceph.sh && sudo ./shutdown_ceph.sh"

cat <<'DONE' | sudo bash -
#!/bin/bash
set -e -o pipefail
[ -d /etc/ceph.bak ] && rm -fr /etc/ceph.bak
[ -d /etc/ceph ] && mv /etc/ceph /etc/ceph.bak
cp -r ceph_conf /etc/ceph
/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_mon.sh
[ -d ceph_conf ] && rm -r ceph_conf
cp -r /etc/ceph ceph_conf
chown -R ${USER}:${USER} ceph_conf
DONE

${basedir}/deliver.sh hosts/k8s.list ceph_conf /etc/ceph sudo root 0750

cat >scripts/deploy_mon.sh <<'DONE'
#!/bin/bash

id=$(hostname -s)

[ -d /var/lib/ceph ] && rm -fr /var/lib/ceph
[ -d /var/log/ceph ] && rm -fr /var/log/ceph
[ -d /var/run/ceph ] && rm -fr /var/run/ceph

set -e -o pipefail

mkdir -p /var/lib/ceph
mkdir -p /var/run/ceph
mkdir -p /var/log/ceph

systemctl daemon-reload
systemctl enable ceph-mon.target
systemctl enable ceph-mon@${id}

/opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/mkfs_ceph_mon.sh

systemctl start ceph-mon.target
systemctl restart ceph-mon.target
systemctl status ceph-mon@${id}
echo ok
DONE

./upload.sh hosts/k8s.list scripts/deploy_mon.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_mon.sh && sudo ./deploy_mon.sh"
