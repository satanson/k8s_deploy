#!/bin/bash

set -e -o pipefail

hostList=${1:?"missing 'hostList'"};shift
stunnel=${1:?"missing 'stunnel'"};shift

test -d ${stunnel}

[ -f ${stunnel}.tgz ] && rm -fr ${stunnel}.tgz
tar czvf ${stunnel}.tgz stunnel

./upload.sh ${hostList} ${stunnel}.tgz

cat >scripts/deploy_stunnel.sh <<DONE
#!/bin/bash
set -e -o pipefail

cd /tmp/
[ -d ${stunnel} ] && rm -fr ${stunnel:?"undefined"}
tar xzvf ${stunnel}.tgz
sudo cp ${stunnel}/* /etc/stunnel/
sudo perl -i.bak -lpe 's/^\s*ENABLED\s*=\s*0\s*$/ENABLED=1/' /etc/init.d/stunnel4
sudo perl -i.bak -lpe 's/^\s*ENABLED\s*=\s*0\s*$/ENABLED=1/' /etc/default/stunnel4
sudo systemctl daemon-reload
sudo systemctl restart stunnel4
sudo systemctl status stunnel4
DONE

./doall_script.sh ${hostList} scripts/deploy_stunnel.sh
