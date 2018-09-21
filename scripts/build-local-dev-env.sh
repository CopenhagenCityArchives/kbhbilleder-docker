#!/usr/bin/env bash
#
# Build a local dev-env image - should not be pushed as it uses whatever
# revisions has been check out locally.
#
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}/../

# Build a local image with the current kbhbilleder-docker in context.
time docker build --tag eu.gcr.io/kbh-billeder/kbhbilleder-docker:latest -f "${SCRIPT_DIR}/../docker/dev-env/Dockerfile-dev-env" "${SCRIPT_DIR}/../"
