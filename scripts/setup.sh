#!/bin/bash

# On first start after build
if [ ! "$(ls -A /data)" ]; then
    # Move over configuration files
    mv /tmp/conf/* /data/
    rm -rf /tmp/conf

    # Add functions from utils.sh
    . ${SCRIPTS:-/}utils.sh

    # Accept EULA
    writeEula

    # Download Spigot
    curl -L -o /data/spigot.jar https://download.getbukkit.org/spigot/spigot-1.17.1.jar

    # Download Dynmap
    curl -L -o /data/plugins/Dynmap.jar https://dev.bukkit.org/projects/dynmap/files/3435158/download

    # Download CoreProtect
    curl -L -o /data/plugins/CoreProtect.jar https://github.com/PlayPro/CoreProtect/releases/download/v20.1/CoreProtect-20.1.jar

    # Download SQL connector
    curl -L -o /home/pingu/msql.deb https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.26-1ubuntu20.04_all.deb
    apt install -y /home/pingu/msql.deb

    # Set up rcon
    curl -L -o /home/pingu/rcon.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.4.8/rcon-cli_1.4.8_linux_amd64.tar.gz
    tar -xf /home/pingu/rcon.tar.gz -C /home/pingu/
fi

# start ssh server
ssh-keygen -A
/usr/sbin/sshd

exec /start.sh
