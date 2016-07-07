#!/bin/sh

echo "Initializing the Database..."
openvasmd --rebuild

echo "Creating an administrator user for OpenVAS..."
openvasmd --create-user=admin

echo "Launching openvas-manager..."
exec /usr/local/sbin/openvasmd $*
