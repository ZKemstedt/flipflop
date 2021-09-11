# syntax=docker/dockerfile:1

FROM adoptopenjdk:16-jre

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    openssh-server \
    sudo \
    curl wget \
    git \
    unzip \
    dos2unix \
    vim \
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

# Move conf over
RUN mkdir /tmp/conf
COPY conf /tmp/conf
COPY scripts/* /

# dos2unix fixes line endings for scripts
RUN dos2unix /start* && chmod +x /start*

WORKDIR /data

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/setup.sh" ]
