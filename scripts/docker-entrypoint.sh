#!/bin/sh


# prepare run dir
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi

echo "=== LOG Generating SSH Keys ==="
ssh-keygen -A

echo "=== LOG Creating /var/vrun/sshd ==="
mkdir -p /var/run/sshd

# echo "=== LOG Starting sshd ==="
# /usr/sbin/sshd

echo "=== LOG cd-ing to /spigot"
cd /spigot

echo "=== LOG starting spigot"
screen -d -m -S "spigot" /opt/openjdk-16/bin/java -Xms${START_RAM_USAGE} -Xmx${MAX_RAM_USAGE} -Dcom.mojang.eula.agree=true -jar spigot*.jar nogui 
# /opt/openjdk-16/bin/java -Dcom.mojang.eula.agree=true -jar spigot*.jar nogui &

# useful future params for specifying configuration file locations

# --world-dir <directory>
# --plugins <directory>
# --config <config file>.yml
# --bukkit-settings <file>.yml
# --commands-settings <file>.yml

echo "=== LOG starting sshd ==="
/usr/sbin/sshd

echo "=== LOG Entrypoint Done, will now tail MC-server logs ==="

exec "$@"