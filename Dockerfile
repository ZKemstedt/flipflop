# syntax=docker/dockerfile:1

FROM openjdk:16-alpine3.13

RUN apk add --update --no-cache git shadow vim wget doas sed openssh curl

# Add a penguin for running the server
RUN groupadd -g 1000 pingu \
  && useradd --no-log-init -m -u 1000 -g pingu pingu \
  && echo "pingu:skt" | chpasswd \
  && echo "permit pingu as root" >> /etc/doas.conf \
  && chown pingu:pingu /home/pingu

# Create an igloo where it stores server files
RUN mkdir -m 770 /data && \
    chown pingu:pingu /data

# Move scripts over
COPY ./scripts /scripts
RUN chmod +x /scripts/start.sh /scripts/runserver.sh /scripts/docker-entrypoint.sh

# SSH key setup
# put public ssh-keys in authorized_keys (file at root in the repository)
RUN mkdir /home/minecraft/.ssh \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
COPY .authorized_keys /home/minecraft/.ssh/authorized_keys

# Temporarily disabled because I'm really frustrated about having to
# remove entries from my hosts file every time I rebuild the image
#RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

# Build Spigot
RUN mkdir /tmp/build /spigot && cd /tmp/build \
    && curl -o BuildTools.jar \
    https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
    && java -jar BuildTools.jar --output-dir /spigot

ENTRYPOINT [ "/scripts/docker-entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D" ]

# TODO: (or just launch it in the background from the entrypoint?)
#CMD /scripts/start.sh
