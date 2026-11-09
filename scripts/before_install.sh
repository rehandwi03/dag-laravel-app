#!/bin/sh
set -e

if ! command -v docker >/dev/null 2>&1; then
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y docker
  elif command -v yum >/dev/null 2>&1; then
    yum install -y docker
  elif command -v apt-get >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
  else
    echo "Unsupported operating system: Docker is not installed" >&2
    exit 1
  fi
fi

systemctl enable docker
systemctl start docker
