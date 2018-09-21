#!/usr/bin/env bash
#
# Rebuild a manual "npm link"-like structure that uses absolute paths to be
# compatible with Docker.
#
set -euo pipefail

cd /home/node/kbh-billeder/node_modules

rm -rf collections-online
rm -rf collections-online-cumulus
ln -vs /usr/local/lib/node_modules/collections-online collections-online
ln -vs /usr/local/lib/node_modules/collections-online-cumulus collections-online-cumulus

cd /usr/local/lib/node_modules/collections-online-cumulus/node_modules
rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online

cd /usr/local/lib/node_modules/collections-online/node_modules
rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online
