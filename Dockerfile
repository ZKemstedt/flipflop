# syntax=docker/dockerfile:1

FROM adoptopenjdk:16-jre

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    openssh-server \
    curl \
    git \
    # unzip \
    dos2unix \
    && apt-get clean

# Add a penguin for running the server
RUN groupadd -g 1000 pingu \
    && useradd --no-log-init -m -u 1000 -g pingu pingu \
    && echo "pingu:skt" | chpasswd \
    && chown pingu:pingu /home/pingu

# SSH key setup
RUN mkdir /run/sshd /home/pingu/.ssh 
COPY ./authorized_keys /home/pingu/.ssh/authorized_keys
RUN chown pingu:pingu /home/pingu/.ssh/authorized_keys \
    && chmod 600 /home/pingu/.ssh/authorized_keys


WORKDIR /data

# Move scripts over
COPY scripts/* /

#Move dynmap config
COPY conf/plugins/dynmap/configuration.txt /data/plugins/dynmap/

# dos2unix fixes line endings
RUN dos2unix /*.sh && chmod +x /start*

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/start.sh" ]
