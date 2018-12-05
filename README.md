jenkins-swarm-slave-nlm-docker
==============================

Jenkins Swarmer slave with Maven, Xvfb and Graphviz

# Building

```bash
docker build . -t villekah/jenkins-swarm-slave-nlm-docker:latest
```

# Running

myjenkins is running in the same Docker container

```bash
docker run --rm -e "JAVA_OPTS=-Dfile.encoding=UTF8 -Xmx2G" \
-v /var/run/docker.sock:/var/run/docker.sock \
--network dnet1 \
villekah/jenkins-swarm-slave-nlm-docker:latest \
-master http://myjenkins:8080 \
-username jenkins \
-password jenkins \
-executors 1
```

# Or with the script


```bash
Usage: ./build-and-run.sh <master-url> <jenkins-master-username> <jenkins-master-password> [network]
Network is the fourth parameter and optional. For example: dnet1.

./build-and-run.sh \
http://myjenkins:8080 \
jenkins \
jenkins \
dnet1
```
