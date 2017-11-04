#!/bin/sh -eu

REPOTPL=/etc/pkg/FreeBSD.conf
ETCD=/usr/local/etc/pkg/repos
REPOF=${ETCD}/FreeBSD.conf

mkdir -vp ${ETCD}

cat ${REPOTPL} | \
    sed 's#\${ABI}/quarterly#\${ABI}/latest#' >${REPOF}

pkg clean -ya
rm -vf /var/db/pkg/repo-*.sqlite

pkg update -f
pkg-static upgrade -y

pkg install -y rsync sudo virtualbox-ose-additions-nox11

pkg noauto | sort
