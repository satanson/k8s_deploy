#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

${basedir}/deliver.sh hosts/k8s.list ceph_conf /etc/ceph sudo root 0755

cat >scripts/deploy_osd.sh <<'DONE'
#!/bin/bash

systemctl daemon-reload
set +e +o pipefail
systemctl stop ceph-osd.target
systemctl stop ceph-osd@.service
systemctl disable ceph-osd.target
systemctl disable ceph-osd@.service
for id in $(ls /var/lib/ceph|perl -lne 'print $1 if /^osd-(\d+)$/');do
  systemctl stop ceph-osd@${id}
  systemctl disable ceph-osd@${id}
done

set -e +o pipefail

systemctl enable ceph-osd.target

for dev in $(ls /dev/nvme0n*);do
  /opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_osd.sh ${dev}
done

for id in $(ls /var/lib/ceph|perl -lne 'print $1 if /^osd-(\d+)$/');do
  systemctl enable ceph-osd@${id}
  systemctl start ceph-osd@${id}
  systemctl restart ceph-osd@${id}
  systemctl status ceph-osd@${id}
done

DONE

./upload.sh hosts/k8s.list scripts/deploy_osd.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_osd.sh && sudo ./deploy_osd.sh"
