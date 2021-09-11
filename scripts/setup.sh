#!/bin/bash

if [ ! "$(ls -A /data)" ]; then

    # Add functions from utils.sh
    . ${SCRIPTS:-/}utils.sh

    # accept EULA
    writeEula

    mkdir /data/plugins

    # Move over the config files
    mv /tmp/conf/* /data/

    # Download Spigot
    curl -L -o /data/spigot.jar https://download.getbukkit.org/spigot/spigot-1.17.1.jar

    # Download Dynmap
    curl -L -o /data/plugins/Dynmap.jar https://dev.bukkit.org/projects/dynmap/files/3435158/download

    # Download CoreProtect
    curl -L -o /data/plugins/CoreProtect.jar https://www.spigotmc.org/resources/coreprotect.8631/download

    # Download SQL connector
    curl -L -o /data/plugins/msql.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz

    tar -xf msql.tar.gz -C mysql && rm msql.tar.gz
    
    mv /data/plugins/mysql/*.jar /data/plugins/

else
    rm -rf /tmp/conf
fi

# start ssh server
ssh-keygen -A
/usr/sbin/sshd

exec /start.sh