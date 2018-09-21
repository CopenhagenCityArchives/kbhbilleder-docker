#!/usr/bin/env bash
set -euox pipefail
IFS=$'\n\t'

if [[ -z "${CIRCLECI_TOKEN:-}" ]] ; then
    echo "Missing CIRCLECI_TOKEN environment variable, create one at https://circleci.com/account/api"
    exit 1
fi

# Trigger a build of the "build" workflow job
curl -u "${CIRCLECI_TOKEN}": -d build_parameters[CIRCLE_JOB]=build https://circleci.com/api/v1.1/project/github/CopenhagenCityArchives/kbh-billeder/tree/master
