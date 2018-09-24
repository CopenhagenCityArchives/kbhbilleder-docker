#!/usr/bin/env bash
#
# Clone repositories needed to do a build and build a dev-env image.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Only clone if it have not been volumed in for dev purposes.
if [[ ! -d /build/kbhbilleder-docker ]] ; then
    git clone --branch="$KBH_BILLEDER_DOCKER_BRANCH" https://github.com/CopenhagenCityArchives/kbhbilleder-docker /build/kbhbilleder-docker

    # Get clones of the projects we'll need.
    git clone --branch="$KBH_BILLEDER_BRANCH" https://github.com/CopenhagenCityArchives/kbh-billeder.git /build/kbhbilleder-docker/projects/kbh-billeder
    git clone --branch="$COLLECTIONS_ONLINE_BRANCH" https://github.com/CopenhagenCityArchives/collections-online.git /build/kbhbilleder-docker/projects/collections-online
    git clone --branch="$COLLECTIONS_ONLINE_CUMULUS_BRANCH" https://github.com/CopenhagenCityArchives/collections-online-cumulus.git /build/kbhbilleder-docker/projects/collections-online-cumulus

    # This file is required to exist
    touch /build/kbhbilleder-docker/projects/kbh-billeder/google-key.json
fi

cd /build/kbhbilleder-docker

# Do a build with the kbhbilleder-docker setup in context which should provide
# Dockerfile-dev-env with all the files it needs.
docker build --tag eu.gcr.io/kbh-billeder/kbhbilleder-docker:latest -f "docker/dev-env/Dockerfile-dev-env" .
