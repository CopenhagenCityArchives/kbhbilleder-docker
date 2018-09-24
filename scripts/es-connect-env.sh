#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -eq 0 ]] ; then
    echo "Syntax: $0 <beta|production>"
    exit 1
fi

echo "Setting up a port-forward from ${1} ES to localhost:9300 ... please wait (you can stop the forward by pressing ctrl-c)"
kubectl port-forward -n $1 $(kubectl get -n $1 pod -l "component=elasticsearch" -o jsonpath='{.items[0].metadata.name}') 9300:9200

