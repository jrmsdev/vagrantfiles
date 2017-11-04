#!/bin/sh -eu

# cleanup pkg and freebsd-update data
echo '*** cleanup pkg and freebsd-update'
pkg clean -ya
pkg autoremove -y
rm -vf /var/db/pkg/repo-* /var/cache/pkg/*
rm -vrf /usr/lib/debug/* /var/tmp/* /var/db/freebsd-update/*
sync

# fill with 0s the swap partition
echo '*** zero swapfs'
SWAPFS=/dev/gpt/swapfs
swapoff ${SWAPFS}
dd if=/dev/zero of=${SWAPFS} bs=1M || echo "dd status ignored: $?"
swapon ${SWAPFS}
swapinfo
sync

# fill with 0s the free space on rootfs
echo '*** zero rootfs'
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd status ignored: $?"
rm -f /EMPTY
sync

exit 0
