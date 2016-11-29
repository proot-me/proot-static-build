#!/bin/bash

### VARIABLES

#DOCKER_IMAGE='proot/proot-buildenv:latest'
DOCKER_IMAGE='debian_care'
CONTAINER_USERNAME='dummy'
CONTAINER_GROUPNAME='dummy'
TARGET_DIR='/opt/build/target'
GROUP_ID=$(id -g)
USER_ID=$(id -u)

### FUNCTIONS

create_user_cmd()
{
  if [[ ${USER_ID} -ne 0 ]]; then
    echo \
      groupadd -f -g $GROUP_ID $CONTAINER_GROUPNAME '&&' \
      useradd -u $USER_ID -g ${GROUP_ID} $CONTAINER_USERNAME '&&' \
      chown -R ${USER_ID}:${GROUP_ID} /opt/build
  else
    echo echo 'Running build as root...'
  fi
}

execute_as_cmd()
{
  if [[ ${USER_ID} -ne 0 ]]; then
    echo \
      su $CONTAINER_USERNAME -c
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

mkdir -p ./target
eval docker run \
    --rm=true \
    -v $(pwd)/target:${TARGET_DIR} \
    -w /opt/build \
    $DOCKER_IMAGE \
    /bin/bash -ci $(full_container_cmd $@)

# -a stdout \
