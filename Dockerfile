FROM java:latest

MAINTAINER Petri Sirkkala <sirpete@iki.fi>

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN \
  apt-get update && \
  apt-get -y install \
    apt-transport-https software-properties-common && \
  apt-get -y install \
    build-essential \
    iceweasel \
    git \
    maven \
    rsync \
    locales \
    sudo \
    x11vnc \
    Xvfb \
    graphviz && \
  update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
  rm -rf /var/lib/apt/lists/* # 2015-11-13

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
RUN apt-get update && apt-get install -y docker-ce
# install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose


ENV JENKINS_SWARM_VERSION 3.14
ENV HOME /home/jenkins-slave

RUN \
  useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave && \
  usermod -a -G sudo jenkins-slave && \
  echo "jenkins-slave ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/jenkins-slave && \
  curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar \
    https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar && \
  chmod 755 /usr/share/jenkins

# Set the locale
RUN \
  echo "LANG=en_US.UTF-8" > /etc/default/locale && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JAVA_OPTS -Duser.country=US -Duser.language=en

# Set the timezone
RUN \
  ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime
ENV TZ Europe/Helsinki

USER jenkins-slave

COPY jenkins-slave-entrypoint.sh /usr/local/bin/jenkins-slave-entrypoint.sh
COPY bowerrc /home/jenkins-slave/.bowerrc

VOLUME /home/jenkins-slave

WORKDIR /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave-entrypoint.sh"]
