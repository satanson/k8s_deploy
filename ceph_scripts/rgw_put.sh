#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)

bucket=${1:?"missing 'user'"};shift
rgw=${1:?"missing 'rgw'"};shift
file=${1:?"missing 'file'"};shift
file=$(readlink -f ${file})
name=$(basename ${file})

cd ${basedir}

swift_secret_key=$(radosgw-admin user info --uid=${bucket} |perl -lne 'print $1 if /^\s*"secret_key"\s*:\s*"(\w+)"\s*$/' |tail -1)
xauth_token=$(curl -v -H "Content-Type:application/json" -H "x-auth-user:${bucket}:swift" -H "x-auth-key:${swift_secret_key}" -X GET http://127.0.0.1:7480/auth/1.0 2>&1|perl -lne 'print $1 if/^<\s*X-Auth-Token\s*:\s*(\w+)\s*$/')

#echo "swift_secret_key=${swift_secret_key} xauth_token=${xauth_token}"
curl -v -H "Content-Type:application/json"  -H "X-Auth-Token:${xauth_token}" -F "file=@${file}" -X PUT http://${rgw}:7480/swift/v1/${bucket}/${name}
