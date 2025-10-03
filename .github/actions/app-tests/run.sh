#!/usr/bin/env bash
set -euo pipefail

APP="${1:?}"
IMAGE="${2:?}"

echo "pulling image"
docker pull ${IMAGE}"

echo "Starting Container for Log Fetching..."
CONTAINER_ID=$(docker run -d --name tmp_test_container "${IMAGE}")

sleep 5

if [[ -x "$(command -v container-structure-test)" ]]; then
    echo "Running CST..."
    container-structure-test test --image "${IMAGE}" --config "./apps/${APP}/tests.yaml"
elif [[ -x "$(command -v goss)" && -x "$(command -v dgoss)" ]]; then
    export GOSS_FILE="./apps/${APP}/tests.yaml"
    export GOSS_OPTS="--retry-timeout 60s --sleep 1s"
    if [ -f "$GOSS_FILE" ]; then
        echo "Running GOSS.."

    dgoss run "${IMAGE}" || { docker logs "${CONTAINER_ID}"; exit 1; }
    else
        echo "GOSS file not found for app ${APP}, skipping GOSS tests."
    fi
else
    echo "No testing tool found. Exiting."
    docker logs "${CONTAINER_ID}"
    exit 1
fi

echo "Container Logs:"
docker logs "${CONTAINER_ID}"
