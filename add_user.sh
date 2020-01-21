#!/bin/bash
set -e -o pipefail
user=${1:?"missing 'user'"};shift

useradd -s /bin/bash -m ${user}
usermod -a -G sudo ${user}
echo "${user} ALL=(ALL) NOPASSWD : ALL" > /etc/sudoers.d/${user}
chmod 0440 /etc/sudoers.d/${user}
