#!/bin/sh

set -e

mkdir -vp ~vagrant/src ~vagrant/pkg ~vagrant/bin
chown -vR vagrant:vagrant ~vagrant/src ~vagrant/pkg ~vagrant/bin

if ! grep -F 'export GOPATH' ~vagrant/.bashrc; then
    echo 'export GOPATH=~vagrant' >>~vagrant/.bashrc
    echo 'export PATH=$GOPATH/bin:$PATH' >>~vagrant/.bashrc
fi

exit 0
