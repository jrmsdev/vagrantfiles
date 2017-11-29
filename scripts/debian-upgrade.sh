#!/bin/sh

DEBDIST=${1:?'debian dist?'}
shift
DEBSUITE="$@"

if test -z "$DEBSUITE"; then
    DEBSUITE=main
fi

set -e
export DEBIAN_FRONTEND=noninteractive

DEBDOM=deb.debian.org
CF=/etc/apt/sources.list

echo "deb http://${DEBDOM}/debian ${DEBDIST} ${DEBSUITE}" >${CF}

if test "unstable" != "${DEBDIST}"; then
    echo "deb http://${DEBDOM}/debian-security ${DEBDIST}/updates ${DEBSUITE}" >>${CF}
fi

apt-get clean
apt-get update
apt-get dist-upgrade -y --purge
apt-get install -y --no-install-recommends rsync
apt-get clean
apt-get autoremove -y --purge

rm -rf /var/lib/apt/lists/*
rm -f /var/cache/apt/archives/*.deb
rm -f /var/cache/apt/*cache.bin

exit 0
