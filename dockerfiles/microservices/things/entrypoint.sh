#!/bin/sh
set -e

PACKAGE_FILE=/app/package.json
if [ -f "$PACKAGE_FILE" ]; then
  echo "npm install..."
  npm install
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"