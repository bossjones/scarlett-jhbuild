#!/usr/bin/env bash

_DIR=$1

find ${_DIR} -name "*.tmp" -exec rm {} \; && \
find ${_DIR} -type d -name ".git" -prune -exec rm -rf {} \;
