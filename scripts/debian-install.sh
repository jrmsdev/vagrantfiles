#!/bin/sh

set -e
export DEBIAN_FRONTEND=noninteractive

apt-get clean
apt-get update

apt-get install -y --no-install-recommends --purge $@

apt-get clean
apt-get autoremove -y --purge

rm -rf /var/lib/apt/lists/*
rm -f /var/cache/apt/archives/*.deb
rm -f /var/cache/apt/*cache.bin

exit 0
