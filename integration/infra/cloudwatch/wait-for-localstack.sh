#!/bin/bash
set -euo pipefail

LOCALSTACK_URL="${LOCALSTACK_URL:-http://localhost:4566}"
MAX_ATTEMPTS=30
SLEEP_SECONDS=3

echo "Waiting for LocalStack to be ready..."
for attempt in $(seq 1 $MAX_ATTEMPTS); do
  status=$(curl -s -o /dev/null -w "%{http_code}" "${LOCALSTACK_URL}/_localstack/health" 2>/dev/null || echo "000")
  if [ "$status" = "200" ]; then
    echo "LocalStack is ready (attempt $attempt)."
    exit 0
  fi
  echo "Attempt $attempt/$MAX_ATTEMPTS: HTTP status=$status. Sleeping ${SLEEP_SECONDS}s..."
  sleep $SLEEP_SECONDS
done

echo "LocalStack did not become ready after $((MAX_ATTEMPTS * SLEEP_SECONDS)) seconds."
exit 1
