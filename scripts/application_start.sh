#!/bin/sh
set -e

BUNDLE_DIR=$(cd "$(dirname "$0")/.." && pwd)
. "${BUNDLE_DIR}/image_uri.env"

ENV_FILE="${ENV_FILE:-/etc/laravel-app/.env}"
DOCKER_NETWORK="${DOCKER_NETWORK:-laravel-app-net}"

if [ ! -f "${ENV_FILE}" ]; then
  echo "Environment file ${ENV_FILE} not found" >&2
  exit 1
fi

docker network create "${DOCKER_NETWORK}" >/dev/null 2>&1 || true

docker run -d \
  --name laravel-app \
  --restart unless-stopped \
  --network "${DOCKER_NETWORK}" \
  --network-alias laravel-app \
  --env-file "${ENV_FILE}" \
  "${IMAGE_URI}"
