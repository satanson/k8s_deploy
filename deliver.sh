#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)

hostList=${1:?"missing 'hostList'"};shift
file=${1:?"missing 'file'"};shift
file=$(readlink -f ${file})

targetFile=${1:?"missing 'targetFile'"};shift
sudo=${1:?"missing 'sudo'"};shift
user=${1:?"missing 'user'"};shift
mode=${1:?"missing 'mode'"};shift

cd ${basedir}

test -e ${file}

if [ -f ${file} ];then
  ./upload.sh ${hostList} ${file}

  cat >scripts/deliver_file.sh <<- 'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
DONE

  parentDir=$(dirname ${targetFile})
  file=$(basename ${file})
  targetFile=$(basename ${targetFile})

  cat >>scripts/deliver_file.sh <<- DONE
mkdir -p  ${parentDir}
cd ${parentDir}
cp /tmp/${file} ${targetFile}
chown ${user}:${user} ${targetFile}
chmod ${mode} ${targetFile}
DONE

  if [ -n "${sudo}" ];then
    sudo="sudo"
  fi
  ./upload.sh ${hostList} scripts/deliver_file.sh
  ./doall.sh ${hostList} "chmod a+x /tmp/deliver_file.sh; ${sudo} /tmp/deliver_file.sh"
elif [ -d ${file} ];then
  dir0=$(dirname ${file})
  file0=$(basename ${file})

  if [ "x${dir0}x" != "x${basedir}x" ];then
    [ -d ${file0}.bak ] && rm -fr ${file0:?"undefined"}.bak
    [ -d ${file0} ] && mv ${file0} ${file0}.bak
    cp -r ${file} ./
  fi

  file=${file0}
  [ -f ${file}.tgz ] && rm -fr ${file}.tgz
  tar czvf ${file}.tgz ${file}
  ./upload.sh ${hostList} ${file}.tgz
  
  cat >scripts/deliver_dir.sh <<- 'DONE'
#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
DONE
  parentDir=$(dirname ${targetFile})
  targetFile=$(basename ${targetFile})
  cat >>scripts/deliver_dir.sh <<- DONE
mkdir -p ${parentDir}
cd ${parentDir}
[ -d ${file}.bak ] && rm -fr ${file}.bak 
[ -d ${file} ] && mv ${file} ${file}.bak
[ -d ${targetFile}.bak ] && rm -fr ${targetFile}.bak
[ -d ${targetFile} ] && mv ${targetFile} ${targetFile}.bak
tar xzvf /tmp/${file}.tgz 
if [ "x${file}x" != "x${targetFile}x" ];then
  mv ${file} ${targetFile}
fi
chown -R ${user}:${user} ${targetFile}
chmod -R ${mode} ${targetFile}
DONE
  if [ -n "${sudo}" ];then
    sudo="sudo"
  fi
  ./upload.sh ${hostList} scripts/deliver_dir.sh
  ./doall.sh ${hostList} "chmod a+x /tmp/deliver_dir.sh; ${sudo} /tmp/deliver_dir.sh"
fi
