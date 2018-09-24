#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -z "${ASSET:-}" ]] ; then
    echo "Missing ASSET environment variable, prefix the command with eg. ASSET=kbh-arkiv/33480"
    exit 1
fi

cd "${SCRIPT_DIR}/.."
echo "Indexing ${ASSET}"
docker-compose exec node npm run index single ${ASSET}
