#!/bin/sh -eu

PUBKEY_URL=https://raw.github.com/hashicorp/vagrant/master/keys/vagrant.pub

if test 'FreeBSD' == $(uname -s); then
    fetch -o ~vagrant/.ssh/authorized_keys ${PUBKEY_URL}
else
    wget -O ~vagrant/.ssh/authorized_keys ${PUBKEY_URL}
fi
