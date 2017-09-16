#!/bin/bash

### VARIABLES

DOCKER_IMAGE='proot/proot-buildenv:latest'

BUILD_DIR="/opt/build"
GROUP_ID=$(id -g)
USER_ID=$(id -u)

# must be an absolute path
TARGET_DIR=${TARGET_DIR:-"$(pwd)/target"}
VERSIONS_FILE="$(dirname $(readlink -f $0))/versions.mak"

PROOT_VERSION="$(grep 'proot-version' ${VERSIONS_FILE} | tr -s ' ' | cut -d ' ' -f 3)"
CARE_VERSION="$(grep 'care-version' ${VERSIONS_FILE} | tr -s ' ' | cut -d ' ' -f 3)"
PROOT_TARBALL=${PROOT_TARBALL:-"$(pwd)/src/${PROOT_VERSION}.tar.gz"}
CARE_TARBALL=${CARE_TARBALL:-"$(pwd)/src/${CARE_VERSION}.tar.gz"}

# VOLUMES must be formatted as Docker expects them -> /path_on_host:/mountpoint
# specify multiple volumes using the ; separator
# if no volume specified -> mount latest items
VOLUMES="${PROOT_TARBALL}:/opt/build/packages/${PROOT_VERSION}.tar.gz;${CARE_TARBALL}:/opt/build/packages/${CARE_VERSION}.tar.gz"

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

