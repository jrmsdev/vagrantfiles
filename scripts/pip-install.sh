#!/bin/sh
set -e
PIPOPTS='--upgrade --upgrade-strategy only-if-needed'
pip install $PIPOPTS $@
rm -rf ~/.cache/pip
exit 0
