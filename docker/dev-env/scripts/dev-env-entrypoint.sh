#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -f '/var/run/do_debug' ]] ; then
    /usr/local/bin/npm run start:nodemon-inspect
else
  /usr/local/bin/npm run start:dev
fi
