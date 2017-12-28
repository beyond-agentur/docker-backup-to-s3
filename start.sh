#!/bin/bash

set -e

: ${ACCESS_KEY:?"ACCESS_KEY env variable is required"}
: ${SECRET_KEY:?"SECRET_KEY env variable is required"}
: ${S3_PATH:?"S3_PATH env variable is required"}

export DATA_PATH=${DATA_PATH:-/data/}
export PARAMS=${PARAMS:--q}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

case $1 in 

  backup-once)
    exec /backup.sh
    ;;

  restore)
    : ${VERSION:?"VERSION env variable is required"}
    exec /restore.sh
    ;;

  *)
    echo "Error: must specify operation, one of backup-once, schedule or restore"
    exit 1
esac
