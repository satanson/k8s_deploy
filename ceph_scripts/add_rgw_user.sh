#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

user=${1:?"missing 'user'"};shift

radosgw-admin user create --uid=${user} --display-name="${user}" --system
radosgw-admin subuser create --uid=${user} --subuser=${user}:swift --access=full
radosgw-admin caps add --uid=${user} --caps="users=*"
radosgw-admin caps add --uid=${user} --caps="usage=*"
radosgw-admin caps add --uid=${user} --caps="metadata=*"
radosgw-admin caps add --uid=${user} --caps="buckets=*"
radosgw-admin user modify --uid=${user} --max-buckets=10
swift_secret_key=$(radosgw-admin user info --uid=${user} |perl -lne 'print $1 if /^\s*"secret_key"\s*:\s*"(\w+)"\s*$/' |tail -1)
xauth_token=$(curl -v -H "Content-Type:application/json" -H "x-auth-user:${user}:swift" -H "x-auth-key:${swift_secret_key}" -X GET http://127.0.0.1:7480/auth/1.0 2>&1|perl -lne 'print $1 if/^<\s*X-Auth-Token\s*:\s*(\w+)\s*$/')

echo "swift_secret_key=${swift_secret_key} xauth_token=${xauth_token}"

curl -v -X PUT -H "x-auth-token:${xauth_token}" -H "Content-Type:application/json" "http://127.0.0.1:7480/swift/v1/${user}"
echo "test new rgw" > test.txt
curl -v -H "Content-Type:application/json"  -H "X-Auth-Token:${xauth_token}" -F 'file=@test.txt' -X PUT http://127.0.0.1:7480/swift/v1/${user}/test.txt
curl -v -H "Content-Type:application/json"  -H "X-Auth-Token:${xauth_token}"  -X GET  http://127.0.0.1:7480/swift/v1/${user}/test.txt

ceph osd pool set default.rgw.buckets.data pg_num 3
ceph osd pool set default.rgw.buckets.data pgp_num 3

admin_access_key=$(radosgw-admin user info --uid=${user} |perl -lne 'print $1 if /^\s*"access_key"\s*:\s*"(\w+)"\,$/')
admin_secret_key=$(radosgw-admin user info --uid=${user} |perl -lne 'print $1 if /^\s*"secret_key"\s*:\s*"(\w+)"\s*$/' |head -1)
ceph mgr module enable dashboard
ceph dashboard set-rgw-api-access-key ${admin_access_key}
ceph dashboard set-rgw-api-secret-key ${admin_secret_key}
ceph dashboard set-rgw-api-ssl-verify False
ceph dashboard set-rgw-api-scheme http
