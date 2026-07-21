#!/bin/bash
set -euo pipefail
DOCKERHUB_USER="anushark"
ENVIRONMENT="${1:-dev}"
TAG="${2:-latest}"
FULL_IMAGE="${DOCKERHUB_USER}/${ENVIRONMENT}:${TAG}"
echo ">>> Building Docker image: ${FULL_IMAGE}"
docker build -t "${FULL_IMAGE}" .
echo ">>> Build complete: ${FULL_IMAGE}"

