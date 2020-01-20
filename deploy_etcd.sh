#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

tar czvf etcd_conf.tgz etcd_conf
rm -fr etcd_bin
cp -r /home/vagrant/go_workspace/src/github.com/etcd-io/etcd/bin etcd_bin
tar czvf etcd_bin.tgz etcd_bin

./upload.sh hosts/k8s.list etcd_conf.tgz
./upload.sh hosts/k8s.list etcd_bin.tgz


cat >scripts/deploy_etcd.sh <<'DONE'
#!/bin/bash
set -e -o pipefail
[ -d etcd_conf.bak ] && rm -fr etcd_conf.bak
[ -d etcd_conf ] && mv etcd_conf etcd_conf.bak
tar xzvf etcd_conf.tgz

[ -d etcd_bin.bak ] && rm -fr etcd_bin.bak
[ -d etcd_bin ] && mv etcd_bin etcd_bin.bak
tar xzvf etcd_bin.tgz

set +e +o pipefail
systemctl stop etcd
systemctl disable etcd
killall -9 etcd
set -e -o pipefail

cp etcd_bin/{etcd,etcdctl} /usr/bin/
chmod a+x /usr/bin/{etcd,etcdctl}
cp etcd_conf/etcd.service /etc/systemd/system/

systemctl daemon-reload
[ -d /opt/etcd ] && rm -fr /opt/etcd
mkdir -p /opt/etcd/{data,wals}
cp -r etcd_conf/tls /opt/etcd/
cp etcd_conf/yml/etcd.conf.$(hostname -s).yml /etc/default/etcd.conf.yml

systemctl enable /etc/systemd/system/etcd.service
exec systemctl start etcd 2<&- 1<&- 0<&-  &
DONE

./upload.sh hosts/k8s.list scripts/deploy_etcd.sh
./doall.sh hosts/k8s.list "chmod a+x /tmp/deploy_etcd.sh && sudo /tmp/deploy_etcd.sh"
