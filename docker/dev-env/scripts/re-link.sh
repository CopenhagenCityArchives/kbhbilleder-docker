#!/usr/bin/env bash
#
# Build a local dev-env image - should not be pushed as it uses whatever
# revisions has been check out locally.
#
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}/../projects/kbh-billeder

rm -rf collections-online
rm -rf collections-online-cumulus
ln -vs /usr/local/lib/node_modules/collections-online collections-online
ln -vs /usr/local/lib/node_modules/collections-online-cumulus collections-online-cumulus

cd /usr/local/lib/node_modules/collections-online-cumulus/node_modules
rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online

cd /usr/local/lib/node_modules/collections-online/node_modules
rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online
