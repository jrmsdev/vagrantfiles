#!/bin/sh
set -eux
freebsd-version -ku
freebsd-update fetch
