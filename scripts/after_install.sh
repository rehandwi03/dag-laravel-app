#!/bin/sh
set -e

BUNDLE_DIR=$(cd "$(dirname "$0")/.." && pwd)
. "${BUNDLE_DIR}/image_uri.env"

aws ecr get-login-password --region "${ECR_REGION}" | \
  docker login --username AWS --password-stdin "${IMAGE_URI%%/*}"

docker pull "${IMAGE_URI}"
