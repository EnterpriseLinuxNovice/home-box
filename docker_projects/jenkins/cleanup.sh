#!/usr/bin/env bash
set -euo pipefail

NETWORK_NAME="jenkins"
JENKINS_CONTAINER="jenkins-blueocean"
DIND_CONTAINER="jenkins-docker"

echo "▶ Stopping containers..."

docker stop "$JENKINS_CONTAINER" "$DIND_CONTAINER" 2>/dev/null || true
docker rm   "$JENKINS_CONTAINER" "$DIND_CONTAINER" 2>/dev/null || true

echo "▶ Removing network..."
docker network rm "$NETWORK_NAME" 2>/dev/null || true

echo "✅ Containers and network removed"

echo
read -rp "⚠️  Remove Jenkins volumes (THIS DELETES DATA)? [y/N]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "▶ Removing volumes..."
  docker volume rm jenkins-data jenkins-docker-certs 2>/dev/null || true
  echo "✅ Volumes removed"
else
  echo "ℹ️  Volumes preserved"
fi
