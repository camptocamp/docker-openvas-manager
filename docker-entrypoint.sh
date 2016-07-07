#!/bin/sh

echo "Initializing the Database..."
openvasmd --rebuild

echo "Creating an administrator user for OpenVAS..."
openvasmd --create-user=admin

echo "Getting OpenVAS SCAP database..."
openvas-scapdata-sync

echo "Launching openvas-manager..."
exec /usr/local/sbin/openvasmd $*
