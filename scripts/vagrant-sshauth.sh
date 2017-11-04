#!/bin/sh

PUBKEY_URL=https://raw.github.com/hashicorp/vagrant/master/keys/vagrant.pub

wget -q -O ~vagrant/.ssh/authorized_keys ${PUBKEY_URL}
