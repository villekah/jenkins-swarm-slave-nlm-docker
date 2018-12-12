#!/bin/bash
BASEDIR=$(cd $(dirname $0); /bin/pwd)
cd $BASEDIR

docker build . --tag villekah/jenkins-swarm-slave-nlm-docker:dtjenkins