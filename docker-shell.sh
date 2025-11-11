#!/bin/bash

set -e

export BASE_DIR=$(pwd)
export SECRETS_DIR=$(pwd)/../secrets/
export GCS_BUCKET_NAME="bkos-data-versioning"
export GCP_PROJECT="ac215-project"
export GCP_ZONE="us-central1-a"
export GOOGLE_APPLICATION_CREDENTIALS="/secrets/data-service-account.json"


echo "Building image"
docker build -t data-version-cli -f Dockerfile .

#--privileged \
#-v ~/.gitconfig:/etc/gitconfig \
#-e GCP_PROJECT=$GCP_PROJECT \
#-e GCP_ZONE=$GCP_ZONE \

echo "Running container"
docker run --rm --name data-version-cli -ti \
--cap-add SYS_ADMIN \
--device /dev/fuse \
-v "$BASE_DIR":/app \
-v "$SECRETS_DIR":/secrets \
-e GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS \
-e GCS_BUCKET_NAME=$GCS_BUCKET_NAME data-version-cli
