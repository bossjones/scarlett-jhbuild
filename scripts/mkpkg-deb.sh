#!/usr/bin/env bash

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ~/

pkg_name="jhbuild-scarlett-deps"
pkg_version="1.0.0"
pkg_release="1"
pkg_arch="amd64"
pkg_description="scarlett-jhbuild dependencies"
pkg_license="MIT"
pkg_maintainer="jarvis@theblacktonystark.com"
pkg_url="https://github.com/bossjones/scarlett-jhbuild"
pkg_vendor="Tony Dark Industries"

fpm -s dir -t deb \
    --name $pkg_name \
    --description $pkg_description \
    --license $pkg_license \
    --maintainer $pkg_maintainer \
    --version $pkg_version \
    --iteration ${pkg_release} \
    --architecture $pkg_arch \
    --url $pkg_url \
    --vendor $pkg_vendor \
    --depends python2.7-dev \
    --depends python3.6-dev \
    --after-install ~/dev/scarlett-jhbuild/afterinstall.sh \
    --before-install ~/dev/scarlett-jhbuild/beforeinstall.sh \
    jhbuild=/opt/scarlett-jhbuild \
    .local=/opt/jhbuild

# EG: jhbuild-scarlett-deps_1.0.0-1_amd64.deb
echo '[VERIFY DEB PACKAGE] --------------------------------------------------'
dpkg -c ${pkg_name}_${pkg_version}-${pkg_release}_${pkg_arch}.deb

popd
