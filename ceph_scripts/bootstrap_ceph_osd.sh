#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

dev=${1:?"missing 'dev'"};shift

source ${basedir}/functions.sh

green_print "Phase 1: Generate uuid,osd_secret,id for ceph-osd"

host=$(hostname)
ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$host\b/" /etc/hosts)
uuid=$(uuidgen)
osd_secret=$(ceph-authtool --gen-print-key)

id=$(echo "{\"cephx_secret\": \"${osd_secret}\"}" | \
	   ceph osd new $uuid -i - \
	      -n client.admin -k /etc/ceph/ceph.client.admin.keyring)
cat<<DONE
host=${host}
ip=${ip}
uuid=${uuid}
osd_secret=${osd_secret}
id=${id}
DONE

hrule

#green_print "Phase 2: Decommission old osd.${id}"
#${basedir}/decommission_osd.sh ${id}
#echo "Done"
#hrule

green_print "Phase 2: Generate block device for data and journal"
test -d /var/lib/ceph

osd_data=/var/lib/ceph/osd-${id}
[ -d ${osd_data} ] && rm -fr ${osd_data:?"undefined"}
mkdir -p ${osd_data}
echo bluestore >${osd_data}/type
#echo ${fsid} >${osd_data}/fsid

mkfs.xfs -f ${dev}
#mount -t xfs ${dev} ${osd_data}
#ln -sf ${dev} ${osd_data}/block
hrule

green_print "Phase 3: Generate keyring for osd-${id}"
keyring=${osd_data}/keyring
ceph-authtool --create-keyring ${keyring} --name osd.${id} --cap osd 'allow *' --cap mon 'allow rwx' --add-key ${osd_secret}
#ceph auth add osd.${id} osd 'allow *' mon 'allow rwx' -i ${keyring}
cat ${keyring}
hrule

green_print "Phase 4: format osd_data ${osd_data} for osd.${id}"
ceph-osd --mkfs --mkkey --conf /etc/ceph/ceph.conf --osd-uuid ${uuid} -i ${id} --osd-data ${osd_data} --bluestore-block-path ${dev}
ls ${osd_data}
hrule

green_print "All done!!!"
#ceph-osd -f --conf /etc/ceph/ceph.conf
