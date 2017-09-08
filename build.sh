#!/bin/bash

### VARIABLES

DOCKER_IMAGE='proot/proot-buildenv:latest'

BUILD_DIR="/opt/build"
GROUP_ID=$(id -g)
USER_ID=$(id -u)

# must be an absolute path
TARGET_DIR=${TARGET_DIR:-"$(pwd)/target"}

PROOT_LATEST="$(pwd)/src/proot-v5.1.1.tar.gz"
CARE_LATEST="$(pwd)/src/care-v2.2.2.tar.gz"

# VOLUMES must be formatted as Docker expects them -> /path_on_host:/mountpoint
# specify multiple volumes using the ; separator
# if no volume specified -> mount latest items
VOLUMES=${VOLUMES:-"${PROOT_LATEST}:/opt/build/packages/proot-latest.tar.gz;${CARE_LATEST}:/opt/build/packages/care-latest.tar.gz"}

### FUNCTIONS

mount_volumes() {

  if [[ -n ${VOLUMES} ]]; then
    echo -n "-v ${VOLUMES}" | sed -e 's/;/ -v /g'
  fi

}

### MAIN

mkdir -p "${TARGET_DIR}"
eval docker run \
    --user="${USER_ID}:${GROUP_ID}" \
    -it \
    --rm=true \
    -v "${TARGET_DIR}:/opt/build/target" "$(mount_volumes)" \
    -w "${BUILD_DIR}" \
    -e "PWD=${BUILD_DIR}" \
    "${DOCKER_IMAGE}" \
    "$@"

