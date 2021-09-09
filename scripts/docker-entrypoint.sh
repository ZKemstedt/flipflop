#!/bin/bash
mv /tmp/build/Dynmap.jar /spigot/plugins/
ssh-keygen -A

/scripts/start.sh

exec "$@"