#!/bin/bash

# Start the atlantis server
if [ "${ATLANTIS_ENABLED}" == "true" ]; then
  export ATLANTIS_USER=${ATLANTIS_USER:-atlantis}
  export ATLANTIS_GROUP=${ATLANTIS_GROUP:-atlantis}
  export ATLANTIS_CHAMBER_SERVICE=${ATLANTIS_CHAMBER_SERVICE:-atlantis}
  set -e

  echo "Starting atlantis server..."

  # create atlantis user & group
  (getent group ${ATLANTIS_GROUP} || addgroup ${ATLANTIS_GROUP}) >/dev/null
  (getent passwd ${ATLANTIS_USER} || adduser -S -G ${ATLANTIS_GROUP} ${ATLANTIS_USER}) >/dev/null

  if [ -n "${ATLANTIS_ALLOW_PRIVILEGED_PORTS}" ]; then
    setcap "cap_net_bind_service=+ep" $(which atlantis)
  fi
  exec dumb-init gosu ${ATLANTIS_USER} chamber exec ${ATLANTIS_CHAMBER_SERVICE} -- atlantis server 
fi
