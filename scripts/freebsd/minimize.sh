#!/bin/sh

SWAPFS=/dev/gpt/swapfs

set -eux

pkg clean -ya
rm -vf /var/db/pkg/repo-* /var/cache/pkg/*
rm -vrf /usr/lib/debug/* /var/tmp/* /var/db/freebsd-update/*
sync

swapoff ${SWAPFS}
dd if=/dev/zero of=${SWAPFS} bs=1M || echo "dd status ignored: $?"
swapon ${SWAPFS}
swapinfo
sync

dd if=/dev/zero of=/EMPTY bs=1M || echo "dd status ignored: $?"
rm -f /EMPTY
sync

exit 0
