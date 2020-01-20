#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"undefined 'hostList'"};shift

mkdir -p scripts
snippet="snippet_$(date +"%Y%m%d_%H%M%S.%s")"
cat >scripts/${snippet} <<'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
DONE

cat >>scripts/${snippet} <<DONE
set -x -e -o pipefail
ip=\$(hostname -i)
$* 2>&1 | perl -lne "print qq(\${ip}: \\\$_)"
DONE

${basedir}/upload.sh ${hostList} scripts/${snippet}
${basedir}/doall_oneline_tt.sh ${hostList} chmod a+x /tmp/${snippet}
${basedir}/doall_oneline_tt.sh ${hostList} /tmp/${snippet}
