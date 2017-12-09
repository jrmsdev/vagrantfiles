#!/bin/sh
set -e
PIPOPTS='--upgrade --upgrade-strategy only-if-needed'
reqf=/tmp/jrmsdev.pip.install.requirements
for pkg in $@; do
    echo "${pkg}" >>${reqf}
done
pip install $PIPOPTS -r ${reqf}
rm -f ${reqf}
rm -rf ~/.cache/pip
exit 0
