#!/bin/bash
set -e

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TAG="$1"
ORG="$2"
REPO="$3"

docker build --build-arg HOST_USER_ID="$UID" --tag "${TAG}" \
    --file "Dockerfile.build" $(pwd)


# set -x ;\
# docker build \
#     --build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
#     --build-arg GIT_BRANCH=$(GIT_BRANCH) \
#     --build-arg GIT_SHA=$(GIT_SHA) \
#     --build-arg SCARLETT_ENABLE_SSHD=0 \
#     --build-arg SCARLETT_ENABLE_DBUS='true' \
#     --build-arg SCARLETT_BUILD_GNOME='true' \
#     --build-arg TRAVIS_CI='true' \
# 	--file=Dockerfile \
#     --tag bossjones/boss-docker-jhbuild-pygobject3:$(GIT_SHA) . ; \
# docker tag bossjones/boss-docker-jhbuild-pygobject3:$(GIT_SHA) bossjones/boss-docker-jhbuild-pygobject3:$(TAG) ; \
# docker tag bossjones/boss-docker-jhbuild-pygobject3:$(GIT_SHA) bossjones/boss-docker-jhbuild-pygobject3:latest
