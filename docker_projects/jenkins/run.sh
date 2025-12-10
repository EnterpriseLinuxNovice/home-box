#!/usr/bin/env bash
set -euo pipefail

### CONFIG ###
NETWORK_NAME="jenkins"

DIND_CONTAINER="jenkins-docker"
JENKINS_CONTAINER="jenkins-blueocean"

JENKINS_IMAGE="myjenkins-blueocean:2.528.3-1"

DIND_VOLUME_CERTS="jenkins-docker-certs"
JENKINS_VOLUME_DATA="jenkins-data"

### FUNCTIONS ###
container_running() {
  docker ps --format '{{.Names}}' | grep -q "^$1$"
}

container_exists() {
  docker ps -a --format '{{.Names}}' | grep -q "^$1$"
}

# Setup and/or verify Network bridge
echo "Ensuring Docker network exists..."
docker network inspect "$NETWORK_NAME" >/dev/null 2>&1 \
  || docker network create "$NETWORK_NAME"

# Setup and/or verify Volume
echo "Ensuring Docker volumes exist..."
docker volume inspect "$DIND_VOLUME_CERTS" >/dev/null 2>&1 \
  || docker volume create "$DIND_VOLUME_CERTS"

docker volume inspect "$JENKINS_VOLUME_DATA" >/dev/null 2>&1 \
  || docker volume create "$JENKINS_VOLUME_DATA"

# Setup Docker in docker (dind)
echo "Starting Docker-in-Docker..."
if container_running "$DIND_CONTAINER"; then
  echo " Docker-in-Docker already running"
else
  container_exists "$DIND_CONTAINER" && docker rm "$DIND_CONTAINER"

  docker run --name "$DIND_CONTAINER" --rm --detach \
    --privileged \
    --network "$NETWORK_NAME" \
    --network-alias docker \
    --env DOCKER_TLS_CERTDIR=/certs \
    --volume "$DIND_VOLUME_CERTS":/certs/client \
    --volume "$JENKINS_VOLUME_DATA":/var/jenkins_home \
    --publish 2376:2376 \
    docker:dind --storage-driver overlay2
fi

# Start Jenkins app
echo "Starting Jenkins..."
if container_running "$JENKINS_CONTAINER"; then
  echo "  Jenkins already running"
else
  container_exists "$JENKINS_CONTAINER" && docker rm "$JENKINS_CONTAINER"

  docker run --name "$JENKINS_CONTAINER" --restart=on-failure --detach \
    --network "$NETWORK_NAME" \
    --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client \
    --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 \
    --publish 50000:50000 \
    --volume "$JENKINS_VOLUME_DATA":/var/jenkins_home \
    --volume "$DIND_VOLUME_CERTS":/certs/client:ro \
    "$JENKINS_IMAGE"
fi

echo
echo "Jenkins is starting"
echo "URL: http://localhost:8080"
