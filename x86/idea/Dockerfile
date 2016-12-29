# x86/idea
#
# Running Jetbrains Intellij IDEAD 2016.3.2 Ultimate in a docker container
#
FROM ubuntu:14.04

MAINTAINER Benjamin Weidig <ben@netzgut.net>

# VERSIONS
ARG IDEA_VERSION=2016.3.2
ARG JETTY_VERSION=9.4.0.v20161208

# USER
ARG USERNAME=docker
ARG GROUPID=1000
ARG USERID=1000


# USER PERMISSIONS
# We add a user with the proviced UID/GID to match the persmissions on the base
# system so the files you create won't belong to root
ENV HOME /home/$USERNAME
RUN addgroup --system \
             --gid=$GROUPID \
             $USERNAME
RUN adduser --system \
            --uid=$USERID \
            --gid=$GROUPID \
            --home $HOME \
            --shell /bin/bash $USERNAME

# Enable sudo for the user, just in case
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME  \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# DEPENDENCIES
# Install some software every container might need and clean up afterwards
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/multiverse.list \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    unzip \
    curl \
    software-properties-common \
    light-themes \
    libcanberra-gtk-module \
    git \
    mercurial \
    imagemagick \
    ttf-mscorefonts-installer \
    lib32gcc1 \
    lib32bz2-1.0 \
    lib32ncurses5 \
    lib32stdc++6 \
    lib32z1 \
    libc6-i386 \
    libxml2-utils \
    libxrender1 \
    libxtst6 \
    && rm -rf /var/lib/apt-lists/* \
    && apt-get clean \
    && apt-get purge


# ORACLE JDK 8
RUN apt-add-repository ppa:webupd8team/java -y \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends \
    oracle-java8-installer \
    && rm -rf /var/lib/apt-lists/* \
    && apt-get clean \
    && apt-get purge


# DOWNLOAD IDEA ULTIMATE
ENV IDEA_URL=https://download.jetbrains.com/idea/ideaIU-$IDEA_VERSION.tar.gz
RUN curl -L -o /tmp/idea.tar.gz $IDEA_URL \
    && mkdir -p /opt/intellij \
    && tar -C /opt/intellij --strip-components=1 -xf /tmp/idea.tar.gz   \
    && rm /tmp/idea.tar.gz


# JETTY
# GPG Keys are personal keys of Jetty committers (see https://dev.eclipse.org/mhonarc/lists/jetty-users/msg05220.html)
ENV JETTY_GPG_KEYS \
    # 1024D/8FB67BAC 2006-12-10 Joakim Erdfelt <joakime@apache.org>
    B59B67FD7904984367F931800818D9D68FB67BAC \
    # 1024D/D7C58886 2010-03-09 Jesse McConnell (signing key) <jesse.mcconnell@gmail.com>
    5DE533CB43DAF8BC3E372283E7AE839CD7C58886
ENV JETTY_URL=https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$JETTY_VERSION/jetty-distribution-$JETTY_VERSION.tar.gz

ENV JETTY_HOME /usr/local/jetty
ENV PATH $JETTY_HOME/bin:$PATH
RUN mkdir -p "$JETTY_HOME"
ENV JETTY_BASE /var/lib/jetty
RUN mkdir -p "$JETTY_BASE"
WORKDIR $JETTY_HOME

RUN set -xe \
    && curl -SL -o jetty.tar.gz $JETTY_URL \
    && curl -SL -o jetty.tar.gz.asc "$JETTY_URL.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && for key in $JETTY_GPG_KEYS; do \
          gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; done \
    && gpg --batch --verify jetty.tar.gz.asc jetty.tar.gz \
    && rm -r "$GNUPGHOME" \
    && tar -xvf jetty.tar.gz --strip-components=1 \
    && sed -i '/jetty-logging/d' etc/jetty.conf \
    && rm -fr demo-base javadoc \
    && rm jetty.tar.gz*

# Get the list of modules in the default start.ini and build new base with those modules, then add setuid
RUN modules="$(grep -- ^--module= "$JETTY_HOME/start.ini" | cut -d= -f2 | paste -d, -s)" \
	&& set -xe \
	&& java -jar "$JETTY_HOME/start.jar" --add-to-startd="$modules,setuid"

ENV TMPDIR /tmp/jetty
RUN set -xe \
	&& mkdir -p "$TMPDIR" \
	&& chown -R $USERNAME:$USERNAME $TMPDIR $JETTY_BASE $JETTY_HOME

# SWITCH TO CORRECT USER
USER $USERNAME

# RUN IDEA
CMD /opt/intellij/bin/idea.sh
