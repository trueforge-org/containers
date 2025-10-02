#!/usr/bin/env bash
set -euo pipefail

APP="${1:?}"
IMAGE="${2:?}"

echo "Starting Container for Log Fetching..."
CONTAINER_ID=$(docker run -d --name tmp_test_container "${IMAGE}")

sleep 5

if [[ -x "$(command -v container-structure-test)" ]]; then
    echo "Running CST..."
    container-structure-test test --image "${IMAGE}" --pull --config "./apps/${APP}/tests.yaml"
elif [[ -x "$(command -v goss)" && -x "$(command -v dgoss)" ]]; then
    echo "Running GOSS.."
    export GOSS_FILE="./apps/${APP}/tests.yaml"
    export GOSS_OPTS="--retry-timeout 60s --sleep 1s"
    dgoss run "${IMAGE}" || { docker logs "${CONTAINER_ID}"; exit 1; }
else
    echo "No testing tool found. Exiting."
    exit 1
fi

echo "Container Logs:"

