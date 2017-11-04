#!/bin/sh
set -eux
freebsd-update --not-running-from-cron fetch
freebsd-update --not-running-from-cron install || echo "install error ignored: $?"
freebsd-version -ku
