#!/bin/sh
set -e

if command -v docker >/dev/null 2>&1; then
  docker rm -f laravel-app >/dev/null 2>&1 || true
fi
