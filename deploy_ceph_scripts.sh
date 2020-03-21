#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
hostList=${1:?"missing 'hostList'"};shift
${basedir}/deliver.sh ${hostList} ceph_scripts /opt/ceph_scripts sudo vagrant 0750

script=config_systemd_of_ceph.sh
cat > scripts/${script} <<'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

cp /opt/ceph_scripts/*.target /lib/systemd/system/
cp /opt/ceph_scripts/*.service /lib/systemd/system/
systemctl daemon-reload
DONE

${basedir}/upload.sh ${hostList} scripts/${script}
${basedir}/doall.sh ${hostList} "cd /tmp && chmod a+x ${script} && sudo ./${script}"
