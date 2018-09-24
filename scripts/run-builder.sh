#!/usr/bin/env bash
#
# Build a builder-image that can be used by google cloud builder.
# See kbh-billeder/cloudbuild.yaml
#
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build a dev-env cloud builder, use our local kbhbilleder-docker checkout as
# context.
cd "${SCRIPT_DIR}/../docker/builder"
time docker run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  eu.gcr.io/kbh-billeder/kbhbilleder-container-builder
