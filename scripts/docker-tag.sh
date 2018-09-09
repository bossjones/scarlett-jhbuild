#!/bin/bash
set -e

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TAG="$1"
ORG="$2"
REPO="$3"

docker tag $ORG/$REPO:$GIT_SHA $ORG/$REPO:$TAG
docker tag $ORG/$REPO:$GIT_SHA $ORG/$REPO:latest
