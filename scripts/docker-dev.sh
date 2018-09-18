#!/bin/bash
set -e

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TAG="$1"
ORG="$2"
REPO="$3"

docker run --rm --security-opt label=disable \
    --volume "$(pwd)/:/home/developer/app" \
    --workdir "/home/developer/app" \
    --tty \
    --interactive \
    "${TAG}" bash
