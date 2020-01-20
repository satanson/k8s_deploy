#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
cluster=${cluster:-"ceph"}
host=$(hostname)
id=${host}
ip=$(hostname -i)

test ${host##ceph_mon} != ${host}
mon_data=/home/ceph/mon/${cluster}-${id}
# 1. create mon_data directory
mkdir -p ${mon_data}
rm -fr ${mon_data:?"undefined"}/*

# 2. create tmp dir for retrieve keyring and monmap
mkdir -p ~/tmp
rm -fr ~/tmp/*

# 3. retrieve keyring
ceph auth get mon. -o ~/tmp/keyring
cat ~/tmp/keyring 

# 4. retrieve monmap
ceph mon getmap -o ~/tmp/monmap
monmaptool --print ~/tmp/monmap

# 5. mkfs
ceph-mon -i ${id} --mkfs --monmap ~/tmp/monmap --keyring ~/tmp/keyring 
tree ${mon_data}

# 6.start ceph-mon
./add_libraries.sh 
ceph-mon -i ${id} --public-addr ${ip}:3300,${ip}:6789

# 7. retrieve monmap
sleep 5
ceph mon getmap -o ~/tmp/monmap
monmaptool --print ~/tmp/monmap
