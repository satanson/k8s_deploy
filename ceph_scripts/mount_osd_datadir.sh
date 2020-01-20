#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/env.sh
source ${basedir}/functions.sh

${basedir}/add_libraries.sh

host=$(hostname)
ok=$(perl -e "print qq/ok/ if qq/${host}/=~m/^ceph_osd\\d+$/")
test "x${ok}x" = "xokx"
ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$host\b/" /etc/hosts)
id=${host##ceph_osd}
keyring=/etc/ceph/ceph.osd.${id}.keyring
dataFile=/home/ceph/osd/datablkdev
journalFile=/home/ceph/osd/journalblkdev
dataBlkdev=/dev/datablkdev
journalBlkdev=/dev/journalblkdev
dataMinorId=$((40+${id}*2+0))
journalMinorId=$((40+${id}*2+1))
dataDir=/home/ceph/osd/data-${host}
journalDir=/home/ceph/osd/journal-${host}


green_print "Phase 1: Mount block device for data and journal"

# umount first
df -hl |perl -lne "print \$1 if m{(/dev/loop${dataMinorId}|/dev/loop${journalMinorId}|${dataBlkdev}|${journalBlkdev})}" \
  | xargs -i{} sudo umount '{}'
# losetup detach
losetup --list |perl -lne "print \$1 if m{(/dev/loop${dataMinorId}|/dev/loop${journalMinorId}|${dataBlkdev}|${journalBlkdev})}" \
  | xargs -i{} sudo losetup -d '{}'
# rm blkdev
for blkdev in /dev/loop${dataMinorId} /dev/loop${journalMinorId} ${dataBlkdev} ${journalBlkdev};do
  set +e +o pipefail
  if [ -e ${blkdev} ];then
    sudo losetup -d ${blkdev}
    sudo rm ${blkdev:?"undefined"}
  fi
  set -e -o pipefail
done

sudo mknod ${dataBlkdev} b 7 ${dataMinorId}
sudo mknod ${journalBlkdev} b 7 ${journalMinorId}
sudo losetup ${dataBlkdev} ${dataFile}
sudo losetup ${journalBlkdev} ${journalFile}
#sudo mkfs.xfs -f ${dataBlkdev:?"undefined"}
#sudo mkfs.xfs -f ${journalBlkdev:?"undefined"}

test -d ${dataDir}
test -d ${journalDir}
sudo mount -t xfs ${dataBlkdev} ${dataDir}
sudo mount -t xfs ${journalBlkdev} ${journalDir}

#ln -sf ${dataBlkdev} ${dataDir}/block
sudo chown -R ceph:ceph ${dataBlkdev}
sudo chown -R ceph:ceph ${journalBlkdev}
sudo chown -R ceph:ceph ${dataDir}
sudo chown -R ceph:ceph ${journalDir}
echo "Done"
hrule
