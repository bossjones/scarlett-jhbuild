#!/bin/bash

set -e

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TAG="bossjones/scarlett-jhbuild:latest"

docker build --build-arg HOST_USER_ID="$UID" --tag "${TAG}" \
    --file "Dockerfile.ci" $(pwd)

# 3.7.0-debug
docker run -e PYENV_VERSION='3.6.5' --rm --security-opt label=disable \
    --volume "$(pwd)/:/home/developer/app" --workdir "/home/developer/app" \
    --tty --interactive "${TAG}" bash
