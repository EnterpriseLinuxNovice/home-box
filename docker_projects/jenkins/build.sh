#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="myjenkins-blueocean"
IMAGE_TAG="2.528.3-1"
DOCKERFILE="Dockerfile.jenkins"

echo "Building Jenkins image: ${IMAGE_NAME}:${IMAGE_TAG}"
docker build \
  --file "$DOCKERFILE" \
  --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
  .

echo "Build complete"
