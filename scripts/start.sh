#!/bin/bash

# Add functions from utils.sh
. ${SCRIPTS:-/}utils.sh

# accept EULA
writeEula

# start ssh server
ssh-keygen -A
/usr/sbin/sshd

ls spigot/ -l@

# exec java -Xms2G -Xmx8G -jar /data/spigot*.jar
exec java -Xms2G -Xmx8G -jar /spigot/spigot*.jar
