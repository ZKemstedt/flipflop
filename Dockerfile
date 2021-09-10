# syntax=docker/dockerfile:1

FROM openjdk:16-alpine3.13 as spigot

RUN apk add --update --no-cache git curl

#NOTE if you have a local jar...
# RUN mkdir /spg
# COPY ./spigot-1.17.1.jar /spg/

#NOTE otherwise...
RUN mkdir /tmp/build /spg && cd /spg \
    && curl -o /tmp/build/BuildTools.jar \
    https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
    && java -jar /tmp/build/BuildTools.jar --output-dir /spg


FROM adoptopenjdk:16-jre

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    openssh-server \
    # gosu \
    sudo \
    # net-tools \
    curl wget \
    git \
    unzip \
    dos2unix \
    && apt-get clean

# Add a penguin for running the server
RUN groupadd -g 1000 pingu \
    && useradd --no-log-init -m -u 1000 -g pingu pingu \
    && echo "pingu:skt" | chpasswd \
    && chown pingu:pingu /home/pingu

# SSH key setup
RUN mkdir /run/sshd
RUN mkdir /home/pingu/.ssh 
COPY ./authorized_keys /home/pingu/.ssh/authorized_keys
RUN chown pingu:pingu /home/pingu/.ssh/authorized_keys \
    && chmod 600 /home/pingu/.ssh/authorized_keys

# put public ssh-keys in authorized_keys (file at root in the repository)
    #&& sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# COPY ./authorized_keys /home/pingu/.ssh/authorized_keys

# Generate Fresh rsa keys
# RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key 

RUN mkdir -p /data/plugins && mkdir -p /spigot


COPY --from=spigot /spg/spigot*.jar /spigot/

# Build Spigot
# RUN mkdir /tmp/build && cd /data \
#     && curl -o /tmp/build/BuildTools.jar \
#     https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
#     && java -jar /tmp/build/BuildTools.jar --rev latest --output-dir .


# Build DynMap spigot addon
RUN curl -L -o /data/plugins/Dynmap.jar \
   # https://www.spigotmc.org/resources/dynmap.274/download?version=416268
    #https://github.com/webbukkit/dynmap/releases/download/v3.1-beta-7/Dynmap-3.1-beta7-spigot.jar
    https://dev.bukkit.org/projects/dynmap/files/3435158/download

WORKDIR /data

# Move scripts over
COPY scripts/* /

#Move dynmap config
COPY data/plugins/configuration.txt data/plugins/dynmap/

# dos2unix fixes line endings
# Also set permissions
RUN dos2unix /*.sh && chmod +x /start*

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/start.sh" ]
# CMD [ "/usr/sbin/sshd", "-D" ]
