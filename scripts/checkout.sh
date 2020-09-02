#!/usr/bin/env bash
#
# Ensures you have the correct set of checkouts in /projects
#
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECTS_DIR="${SCRIPT_DIR}/../projects"
DIR_CO="${PROJECTS_DIR}/collections-online"
DIR_COC="${PROJECTS_DIR}/collections-online-cumulus"
DIR_KBH="${PROJECTS_DIR}/kbh-billeder"

syntax () {
  echo "Syntax: $0 <dev|prod>"
}

check_status () {
  CHECKOUT_DIR=$1
  NAME=$2
  cd "${CHECKOUT_DIR}"

  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "** ${NAME} has uncomitted work:"
    git status
    echo
    echo
  fi
}

if [[ $# -eq 0 ]] ; then
  echo "Missing argument"
  syntax
  exit 1
fi
ENV=$1

if [[ "${ENV}" == "dev" ]]; then
  BRANCH_CO=testing
  BRANCH_COC=master
  BRANCH_KBH=master
elif [[ "${ENV}" == "prod" ]]; then
  BRANCH_CO=master
  BRANCH_COC=master
  BRANCH_KBH=production
else
  echo "Unknown argument"
  syntax
  exit 1
fi

cd "${PROJECTS_DIR}"
STATUS=
STATUS+="$(check_status $DIR_CO collections-online)"
STATUS+="$(check_status $DIR_COC collections-online-cumulus)"
STATUS+="$(check_status $DIR_KBH kbh-billeder)"

if [[ -n "${STATUS}" ]]; then
  echo "${STATUS}"
  exit 1
fi

# We're clean
cd "${DIR_CO}" && git checkout "${BRANCH_CO}" && git pull
cd "${DIR_COC}" && git checkout "${BRANCH_COC}" && git pull
cd "${DIR_KBH}" && git checkout "${BRANCH_KBH}" && git pull
