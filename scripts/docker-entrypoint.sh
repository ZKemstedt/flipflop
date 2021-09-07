#!/bin/sh

if [ -z $DEV ]
then
    # generate fresh rsa, dsa keys
    if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
        ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
    fi
    if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
        ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
    fi
fi

# prepare run dir
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi
exec "$@"