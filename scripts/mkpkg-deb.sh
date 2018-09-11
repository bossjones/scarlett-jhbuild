#!/usr/bin/env bash

pushd ~/

pkg_name="jhbuild-scarlett-deps"
pkg_version="1.0.0"
pkg_release="1"
pkg_arch="amd64"

fpm -s dir -t deb \
    --name $pkg_name \
    --version $pkg_version \
    --iteration ${pkg_release} \
    --architecture $pkg_arch \
    jhbuild=/opt/jhbuild

popd
