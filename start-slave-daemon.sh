#!/bin/bash
BASEDIR=$(cd $(dirname $0); /bin/pwd)
cd $BASEDIR

echo
echo "Usage: ./${0##*/} <master-url> <jenkins-master-username> <jenkins-master-password> [network]"
echo "Network is the fourth parameter and optional. For example: dnet1."
echo

MASTER=${1:?Master url is the first required parameter. For example: http://192.168.50.100:8080.}
USERNAME=${2:?Username (for the master) is the second required parameter.}
PASSWORD=${3:?Password (for the master) is the third required parameter.}
NETWORK=${4}

if [ ! -z "${NETWORK}" ]; then
    NETWORK_PARAM="--network ${NETWORK}"
else
    NETWORK_PARAM=""
fi

# See: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
USE_SIBLING_CONTAINERS="-v /var/run/docker.sock:/var/run/docker.sock"
docker run -d --restart=always \
  -e "JAVA_OPTS=-Dfile.encoding=UTF8 -Xmx2G" \
  ${USE_SIBLING_CONTAINERS} \
  ${NETWORK_PARAM} \
  villekah/jenkins-swarm-slave-nlm-docker:dtjenkins \
  -master ${MASTER} \
  -username ${USERNAME} -password ${PASSWORD} \
  -executors 1 \
  -disableSslVerification