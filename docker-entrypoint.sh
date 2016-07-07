#!/bin/sh

openvasmd --rebuild
openvasmd --create-user=admin
exec /usr/local/sbin/openvasmd $*
