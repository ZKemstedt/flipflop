#!/bin/bash

function writeEula {
  if ! echo "# Generated via Docker
# $(date)
eula=${EULA,,}
" >/data/eula.txt; then
    log "ERROR: unable to write eula to /data. Please make sure attached directory is writable by uid=${UID}"
    exit 2
  fi
}


function downloadSpigot {
  if [[ ${VERSION^^} = LATEST ]]; then
    VANILLA_VERSION=$(restify https://getbukkit.org/download/spigot --attribute='property=og:title' | jq -r '.[0] | .attributes | select(.property == "og:title") | .content | split(" ") | .[-1]')
  fi

  if [[ -z $downloadUrl ]]; then
    if versionLessThan 1.16.5; then
      downloadUrl="https://cdn.getbukkit.org/${getbukkitFlavor}/${getbukkitFlavor}-${VANILLA_VERSION}.jar"
    else
      downloadUrl="https://download.getbukkit.org/${getbukkitFlavor}/${getbukkitFlavor}-${VANILLA_VERSION}.jar"
    fi
  fi

  setServerVar
  if [ -f $SERVER ]; then
    # tell curl to only download when newer
    curlArgs="-z $SERVER"
  fi
  if isDebugging; then
    curlArgs="$curlArgs -v"
  fi
  log "Downloading $match from $downloadUrl ..."
  curl -fsSL -o $SERVER $curlArgs "$downloadUrl"
  if [[ $? != 0 || $(grep -c "DOCTYPE html" $SERVER) != 0 ]]; then
    cat <<EOF
ERROR: failed to download from $downloadUrl
       Visit https://getbukkit.org/download/${getbukkitFlavor} to lookup the
       exact version, such as 1.4.6-R0.4-SNAPSHOT or 1.8-R0.1-SNAPSHOT-latest.
       Click into the version entry to find the **exact** version, because something
       like "1.8" is not sufficient according to their download naming.
EOF

    if isDebugging && [[ $(grep -c "DOCTYPE html" $SERVER) != 0 ]]; then
      cat $SERVER
    fi

    # remove invalid download
    rm $SERVER
    exit 3
  fi

  JVM_OPTS="${JVM_OPTS} -DIReallyKnowWhatIAmDoingISwear"
  export JVM_OPTS
}