#!/bin/bash

selectOption(){
  test $# -gt 0
  select opt in $*;do
    echo ${opt}
    break;
  done
}

selectHostList(){
  local dir=${1:?"missing 'dir'"};shift
  dir=${dir%%/}
  local oldshopt=$(set +o)
  set -e -o pipefail
  test -d ${dir}
  local n=$(ls ${dir}|wc -l)
  test ${n} -gt 0
  local selectList=$(ls ${dir}|xargs -i{} basename '{}')
  local chosed=""
  select opt in ${selectList};do
    chosed=${opt}
    break;
  done
  set +vx;eval "${oldshopt}"
  echo ${dir}/${chosed}
}

confirm(){
  echo -n "Are your sure[yes/no]: "
    while : ; do
      read input
      input=$(perl -e "print qq/\L${input}\E/")
      case ${input} in
        y|ye|yes)
          break
          ;;
        n|no)
          echo "operation is cancelled!!!"
          exit 0
          ;;
        *)
          echo -n "invalid choice, choose again!!! [yes|no]: "
          ;;
      esac
    done
}

checkArgument(){
  local name=${1:?"missing 'name'"};shift
  local arg=${1:?"missing 'arg'"};shift
  local alternatives=${1:?"missing 'alternatives'"};shift

  if [ -z ${alternatives} ];then
    echo "ERROR: empty alternatives for '${name}', value='${arg}'" >&2
    exit 1
  fi

  if test x$(perl -e "print qq/${alternatives}/=~/^\w+(?:\|\w+)*$/")x != x1x;then
    echo "ERROR: alternatives must be in format word1|word2|word3..., name='${name}', value='${arg}', alternatives='${alternatives}" >&2
    exit 2
  fi

  if test x$(perl -e "print qq/$arg/=~/^(?:${alternatives})$/")x != x1x; then
    echo "ERROR: unmatched argument, name='${name}', value='${arg}', alternatives='${alternatives}'" >&2
    exit 1
  fi
}

isIn(){
  local arg=${1:?"missing 'arg'"};shift
  local alternatives=${1:?"missing 'alternatives'"};shift

  if [ -z ${alternatives} ];then
    echo "ERROR: empty alternatives, value=${arg}" >&2
    exit 1
  fi

  if test x$(perl -e "print qq/${alternatives}/=~/^\w+(?:\|\w+)*$/")x != x1x;then
    echo "ERROR: alternatives must be in format word1|word2|word3..., value='${arg}', alternatives='${alternatives}" >&2
    exit 2
  fi

  if test x$(perl -e "print qq/$arg/=~/^(?:${alternatives})$/")x != x1x; then
    return 1
  else
    return 0
  fi
}

ipList() {
  local hostList=${1:?"missing 'hostList'"};shift
  local isIpList=$(perl -e "print qq/OK/ if qq{${hostList}} =~ /^(\\d+(\\.\\d+){3})(,\\d+(\\.\\d+){3})*$/")
  local isFile=$([ -f ${hostList} ] && echo OK)
  if [ "x${isIpList}x" = "xOKx" ];then
    echo ${hostList} | perl -aF',' -lne 'print join " ", @F'
  elif [ "x${isFile}x" = "xOKx" ];then
    cat ${hostList}
  else
    echo "ERROR: invalid hostList: '${hostList}'" >&2
    exit 1
  fi
}

#ipList 1.10.168.1,10.1.168.2 
#for i in $(ipList hosts/regionserver.list);do
#  echo $i
#done
