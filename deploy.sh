#!/bin/bash
set -euo pipefail
DOCKERHUB_USER="anushark"
ENVIRONMENT="${1:-dev}"
TAG="${2:-latest}"
FULL_IMAGE="${DOCKERHUB_USER}/${ENVIRONMENT}:${TAG}"
echo ">>> Pushing image: ${FULL_IMAGE}"
docker push "${FULL_IMAGE}"
echo ">>> Deploying"
docker stop devops-build-app 2>/dev/null || true
docker rm devops-build-app 2>/dev/null || true
docker run -d --name devops-build-app --restart unless-stopped -p 80:80 "${FULL_IMAGE}"
echo ">>> Done"

