# syntax=docker/dockerfile:1

# FROM openjdk:16-alpine3.13 as spigot


#Note - Curl doesnt work but WGET does??? WHY
#RUN mkdir /tmp/sql /sql \
#    && wget -O /tmp/sql/mysql.tar.gz \
#    https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz


# #NOTE otherwise...
# RUN mkdir /tmp/build /spg && cd /spg \
#     && curl -o /tmp/build/BuildTools.jar \
#     https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
#     && java -jar /tmp/build/BuildTools.jar --output-dir .

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

# put public ssh-keys in authorized_keys (file at root in the repository)
    #&& sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Generate Fresh rsa keys
# RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key 

# Build Spigot
# RUN mkdir /tmp/build && cd /data \
#     && curl -o /tmp/build/BuildTools.jar \
#     https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
#     && java -jar /tmp/build/BuildTools.jar --rev latest --output-dir .



# Move conf over
RUN mkdir /tmp/conf
COPY conf /tmp/conf
COPY scripts/* /

# dos2unix fixes line endings for scripts
RUN dos2unix /start* && chmod +x /start*

WORKDIR /data

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/setup.sh" ]
