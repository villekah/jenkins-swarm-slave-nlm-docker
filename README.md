jenkins-swarm-slave-nlm-docker
==============================

Jenkins Swarmer slave with Maven, Xvfb and Graphviz

# Building

```bash
docker build . --tag villekah/jenkins-swarm-slave-nlm-docker:dtjenkins
```
or with the script
```bash
./build.sh
```

# Running

If jenkins is running in the same Docker container give same network name as it has ie. dnet1

```bash
docker run --rm -e "JAVA_OPTS=-Dfile.encoding=UTF8 -Xmx2G" \
-v /var/run/docker.sock:/var/run/docker.sock \
--network dnet1 \
villekah/jenkins-swarm-slave-nlm-docker:dtjenkins \
-master http://myjenkins:8080 \
-username jenkins \
-password jenkins \
-executors 1
```

# Or with the script

```bash
Usage: ./run.sh <master-url> <jenkins-master-username> <jenkins-master-password> [network]
Network is the fourth parameter and optional. For example: dnet1.

./start-slave.sh \
http://myjenkins:8080 \
jenkins \
jenkins \
dnet1

or Daemon with same parameters
./start-slave-daemon.sh ...
```
