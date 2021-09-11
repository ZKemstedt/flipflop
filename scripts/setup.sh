#!/bin/bash

if [ ! "$(ls -A /data)" ]; then

    # Add functions from utils.sh
    . ${SCRIPTS:-/}utils.sh

    # accept EULA
    writeEula

    mkdir -p /data/plugins/mysql

    # Download Spigot
    curl -L -o /data/spigot.jar https://download.getbukkit.org/spigot/spigot-1.17.1.jar

    # Download Dynmap
    curl -L -o /data/plugins/Dynmap.jar https://dev.bukkit.org/projects/dynmap/files/3435158/download

    # Download CoreProtect
    curl -L -o /data/plugins/CoreProtect.jar https://github.com/PlayPro/CoreProtect/releases/download/v20.1/CoreProtect-20.1.jar

    # Download SQL connector
    curl -L -o /data/plugins/msql.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz
    tar -xf /data/plugins/msql.tar.gz -C /data/plugins/mysql && rm /data/plugins/msql.tar.gz
    mv /data/plugins/mysql/mysql*/*.jar /data/plugins/
fi

# Move over (WILL OVERWRITE) config files
mv /tmp/conf/* /data/
rm -rf /tmp/conf

# start ssh server
ssh-keygen -A
/usr/sbin/sshd

exec /start.sh