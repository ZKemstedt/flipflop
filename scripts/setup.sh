#!/bin/bash

# On first start after build
if [ ! "$(ls -A /data)" ]; then
    # Move over configuration files
    mkdir /data/plugins

    # Add functions from utils.sh
    . ${SCRIPTS:-/}utils.sh

    # Accept EULA
    writeEula

    # Download Spigot
    curl -L -o /data/spigot.jar https://download.getbukkit.org/spigot/spigot-1.17.1.jar

    # Download Dynmap
    mkdir -p /data/plugins/dynmap
    curl -L -o /data/plugins/Dynmap.jar https://dev.bukkit.org/projects/dynmap/files/3435158/download

    # Download CoreProtect
    mkdir -p /data/plugins/CoreProtect
    curl -L -o /data/plugins/CoreProtect.jar https://github.com/PlayPro/CoreProtect/releases/download/v20.1/CoreProtect-20.1.jar

    # Download SQL connector
    curl -L -o /home/pingu/msql.deb https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.26-1ubuntu20.04_all.deb
    apt install -y /home/pingu/msql.deb

    # Set up rcon
    curl -L -o /home/pingu/rcon.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.4.8/rcon-cli_1.4.8_linux_amd64.tar.gz
    tar -xf /home/pingu/rcon.tar.gz -C /home/pingu/
fi

# On the first entry after building image, add (overwrite) fresh configuration files
if [ -d /tmp/conf ]; then
    # plugin CoreProtect 
    mv plugins/CoreProtect/config.yml /data/plugins/CoreProtect/
    # plugin Dynmap
    mv plugins/dynmap/configuration.txt /data/plugins/dynmap/configuration.txt
    # Core (vanilla / spigot / bukkit)
    mv /tmp/conf/*.yml /data/
    mv /tmp/conf/*.json /data/
    mv /tmp/conf/server.properties /data/
    mv /tmp/conf/server-icon /data/

    rm -rf /tmp/conf
fi

# start ssh server
ssh-keygen -A
/usr/sbin/sshd

exec /start.sh
