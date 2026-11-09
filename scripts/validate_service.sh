#!/bin/sh
set -e

CONTAINER="${BACKEND_CONTAINER_NAME:-laravel-app}"
HEALTH_PATH="${BACKEND_HEALTHCHECK_PATH:-/up}"
HEALTH_URL="http://127.0.0.1${HEALTH_PATH}"

i=0
while [ "${i}" -lt 30 ]; do
  if docker inspect -f '{{.State.Running}}' "${CONTAINER}" >/dev/null 2>&1 \
    && docker exec "${CONTAINER}" php -r 'exit(@file_get_contents($argv[1]) === false ? 1 : 0);' "${HEALTH_URL}" >/dev/null 2>&1; then
    echo "Laravel backend is healthy at ${HEALTH_PATH}"
    exit 0
  fi

  i=$((i + 1))
  sleep 2
done

echo "Service failed health check at ${HEALTH_PATH}" >&2
exit 1
