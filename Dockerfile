# syntax=docker/dockerfile:1

FROM adoptopenjdk:16-jre

# RUN apk add --update --no-cache git shadow vim wget doas sed openssh-server curl

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    openssh-server \
    gosu \
    sudo \
    net-tools \
    curl wget \
    git \
    unzip \
    && apt-get clean

# Add a penguin for running the server
RUN groupadd -g 1000 pingu \
  && useradd --no-log-init -m -u 1000 -g pingu pingu \
  && echo "pingu:skt" | chpasswd \
  && chown pingu:pingu /home/pingu

# Create an igloo where it stores server files
RUN mkdir -m 770 /data && \
    chown pingu:pingu /data

# Move scripts over
COPY ./scripts /scripts
RUN chmod +x /scripts/start.sh /scripts/runserver.sh /scripts/docker-entrypoint.sh

# SSH key setup
RUN mkdir /home/pingu/.ssh 
COPY ./authorized_keys /home/pingu/.ssh/authorized_keys
RUN chown pingu:pingu /home/pingu/.ssh/authorized_keys \
    && chmod 600 /home/pingu/.ssh/authorized_keys
# put public ssh-keys in authorized_keys (file at root in the repository)
    #&& sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# COPY ./authorized_keys /home/pingu/.ssh/authorized_keys

# Temporarily disabled because I'm really frustrated about having to
# remove entries from my hosts file every time I rebuild the image
#RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

# Build Spigot
RUN mkdir /tmp/build /spigot && cd /spigot \
    && curl -o /tmp/build/BuildTools.jar \
    https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
    && java -jar /tmp/build/BuildTools.jar --rev latest --output-dir .


#Build DynMap spigot addon
RUN curl -L -o /tmp/build/Dynmap.jar \
   # https://www.spigotmc.org/resources/dynmap.274/download?version=416268
    #https://github.com/webbukkit/dynmap/releases/download/v3.1-beta-7/Dynmap-3.1-beta7-spigot.jar
    https://dev.bukkit.org/projects/dynmap/files/3435158/download

# Minecraft, Dynmap
EXPOSE 25565 8123

ENV START_RAM_USAGE=2G MAX_RAM_USAGE=8G

ENTRYPOINT [ "/scripts/docker-entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D" ]

# TODO: (or just launch it in the background from the entrypoint?)
#CMD /scripts/start.sh
