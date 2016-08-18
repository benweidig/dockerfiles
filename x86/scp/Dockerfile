# x86/scp
#
# A public-key-file only scp server
#

FROM ubuntu:14.04
MAINTAINER Benjamin Weidig <ben@netzgut.net>

# UPDATE SYSTEM AND INSTALL REQUIRED PACKAGES
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
            openssh-server \
            rssh

# PREPARE USER
ARG DATA=/data
ARG USERID=1000
ARG GROUPID=1000

RUN addgroup --system \
             --gid=$GROUPID \
             docker \
    && adduser --system \
               --uid=$USERID \
               --gid=$GROUPID \
               --home $DATA \
               --shell `which rssh` docker

# PREVENT LOGINS
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# MOVE PUBLIC KEYS
RUN sed -i 's/#AuthorizedKeysFile.*/AuthorizedKeysFile \/authorized_keys/' /etc/ssh/sshd_config

# ENABLE SCP IN RSSH
RUN sed -i 's/#allowscp.*/allowscp/' /etc/rssh.conf

VOLUME $DATA

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
