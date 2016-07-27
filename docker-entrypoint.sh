#!/bin/sh

echo "Initializing the Database..."
openvasmd --rebuild

echo "Creating an administrator user for OpenVAS..."
USER=${OPENVAS_ADMIN_USER:-admin}
openvasmd --create-user=${USER}
if [ -n "${OPENVAS_ADMIN_PASSWORD}" ] ; then
  openvasmd --new-password="${OPENVAS_ADMIN_PASSWORD}" --user=${USER}
fi

echo "Getting OpenVAS SCAP database..."
openvas-scapdata-sync

echo "Getting CERT database..."
openvas-certdata-sync

echo "Launching openvas-manager..."
exec /usr/local/sbin/openvasmd $*
