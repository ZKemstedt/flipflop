#!/bin/bash

writeEula() {
  if ! echo "# Generated via Docker
# $(date)
eula=${EULA,,}
" >/data/eula.txt; then
    log "ERROR: unable to write eula to /data. Please make sure attached directory is writable by uid=${UID}"
    exit 2
  fi
}