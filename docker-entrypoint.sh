#!/bin/sh

openvasmd --rebuild
exec /usr/local/sbin/openvasmd $*
