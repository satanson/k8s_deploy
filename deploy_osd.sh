#!/bin/bash
set -e -o pipefail

tar czvf ceph_scripts.tgz ceph_scripts
tar czvf ceph_conf.tgz ceph_conf

./upload.sh hosts/k8s.list ceph_scripts.tgz
./upload.sh hosts/k8s.list ceph_conf.tgz

cat >scripts/deploy_osd.sh <<'DONE'
#!/bin/bash
rm -fr  /etc/systemd/system/ceph-osd*
set -x -e -o pipefail
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

systemctl daemon-reload
set +e +o pipefail
systemctl disable ceph-osd.target
systemctl disable ceph-osd@.service
set -e +o pipefail

systemctl enable /opt/ceph_scripts/ceph-osd.target
systemctl enable /opt/ceph_scripts/ceph-osd@.service

for dev in $(ls /dev/nvme0n*);do
  /opt/ceph_scripts/run_docker.sh none /opt/ceph_scripts/bootstrap_ceph_osd.sh ${dev}
done

for id in $(ls /var/lib/ceph|perl -lne 'print $1 if /^osd-(\d+)$/');do
  systemctl disable ceph-osd@${id}
  systemctl enable ceph-osd@${id}
  systemctl start ceph-osd@${id}
  systemctl restart ceph-osd@${id}
  systemctl status ceph-osd@${id}
done

DONE

./upload.sh hosts/k8s.list scripts/deploy_osd.sh
./doall.sh hosts/k8s.list "chmod a+x deploy_osd.sh && sudo ./deploy_osd.sh"
