#!/bin/sh
set -e

PACKAGE_FILE=/app/package.json
YARN_LOCK_FILE=/app/yarn.lock
if [ -f "$PACKAGE_FILE" ] && [ -f "$YARN_LOCK_FILE" ]; then
  echo "yarn install..."
  yarn install \
    && yarn prisma:sync \
    && yarn db:migrate \
    && yarn db:seed
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"