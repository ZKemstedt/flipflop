# syntax=docker/dockerfile:1

FROM openjdk:16-alpine3.13 as spigot

RUN apk add --update --no-cache git curl

#NOTE if you have a local jar...
RUN mkdir /spigot
COPY ./spigot-1.17.1.jar /spigot/

#NOTE otherwise...
# RUN mkdir /tmp/build /spigot && cd /spigot \
# && curl -o /tmp/build/BuildTools.jar \
# https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
# && java -jar /tmp/build/BuildTools.jar --output-dir .


FROM openjdk:16-alpine3.13

# SPIGOT
RUN mkdir /spigot

COPY --from=spigot /spigot/spigot*.jar /spigot/


# Packages
RUN apk add --update --no-cache git shadow vim wget doas sed openssh curl screen


# Add a penguin for running the server
RUN groupadd -g 1000 pingu \
  && useradd --no-log-init -m -u 1000 -g pingu pingu \
  && echo "pingu:skt" | chpasswd \
  && echo "permit pingu as root" >> /etc/doas.conf \
  && chown pingu:pingu /home/pingu


#TODO
# Create an igloo where it stores server files
# RUN mkdir -m 770 /data && chown pingu:pingu /data


# Move scripts over
COPY ./scripts /scripts
RUN chmod 770 /scripts/docker-entrypoint.sh


# SSH key setup
# put public ssh-keys in authorized_keys (file at root in the repository)
RUN mkdir /home/pingu/.ssh \
   && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

COPY authorized_keys /home/pingu/.ssh/authorized_keys

# Generate Fresh rsa keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key 


#TODO
# Build DynMap spigot addon
# RUN mkdir /tmp/DynMapBuild/ /DynMap && cd /tmp/DynMapBuild \
#    && curl -o Dynmap.jar \
#    https://github.com/webbukkit/dynmap/releases/download/v3.1-beta-7/Dynmap-3.1-beta7-spigot.jar

RUN mkdir -p /spigot/logs
RUN touch /spigot/logs/latest.log

ENTRYPOINT [ "/scripts/docker-entrypoint.sh" ]
# CMD [ "/usr/sbin/sshd", "-D" ]
CMD [ "/usr/bin/tail", "-f", "/spigot/logs/latest.log" ]

# CMD [ "/opt/openjdk-16/bin/java", "-Xms${START_RAM_USAGE}", "-Xmx${MAX_RAM_USAGE}", "-Dcom.mojang.eula.agree=true" "-jar" "spigot.jar" "nogui" ]
