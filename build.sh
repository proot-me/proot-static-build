#!/bin/bash

### VARIABLES

DOCKER_IMAGE='proot/proot-buildenv:latest'

CONTAINER_USERNAME='dummy'
CONTAINER_GROUPNAME='dummy'
GROUP_ID=$(id -g)
USER_ID=$(id -u)

# must be an absolute path
TARGET_DIR=${TARGET_DIR:-"$(pwd)/target"}

# VOLUMES must be formatted as Docker expects them -> /path_on_host:/mountpoint
# specify multiple volumes using the ; separator
VOLUMES=${VOLUMES:-""}

### FUNCTIONS

create_user_cmd()
{
  if [[ ${USER_ID} -ne 0 ]]; then
    echo \
      groupadd -f -g ${GROUP_ID} ${CONTAINER_GROUPNAME} '&&' \
      useradd -u ${USER_ID} -g ${GROUP_ID} ${CONTAINER_USERNAME} '&&' \
      chown -R ${USER_ID}:${GROUP_ID} /opt/build
  else
    echo echo 'Running build as root...'
  fi
}

mount_volumes() {

  if [[ -n ${VOLUMES} ]]; then
    echo -n "-v ${VOLUMES}" | sed -e 's/;/ -v /g'
  fi

}

execute_as_cmd()
{
  if [[ ${USER_ID} -ne 0 ]]; then
    echo \
      su ${CONTAINER_USERNAME} -c
  else
    echo \
      eval
  fi
}

full_container_cmd()
{
  echo "'$(create_user_cmd) && $(execute_as_cmd) \"$@\"'"
}

### MAIN

mkdir -p ${TARGET_DIR}
eval docker run \
    --rm=true \
    -a stdout \
    -v ${TARGET_DIR}:/opt/build/target $(mount_volumes) \
    -w /opt/build \
    ${DOCKER_IMAGE} \
    /bin/bash -ci $(full_container_cmd $@)

