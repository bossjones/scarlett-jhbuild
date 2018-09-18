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

# fpm --name $pkg_name \
#     --description $pkg_description \
#     --license $pkg_license \
#     --maintainer $pkg_maintainer \
#     --version $pkg_version \
#     --iteration ${pkg_release} \
#     --architecture $pkg_arch \
#     --url $pkg_url \
#     --vendor $pkg_vendor \
#     --after-install $HOME/dev/scarlett-jhbuild/afterinstall.sh \
#     --before-install $HOME/dev/scarlett-jhbuild/beforeinstall.sh \
#     --after-remove $HOME/dev/scarlett-jhbuild/afterremove.sh \
#     --before-remove $HOME/dev/scarlett-jhbuild/beforeremove.sh \
#     --after-upgrade $HOME/dev/scarlett-jhbuild/afterupgrade.sh \
#     --before-upgrade $HOME/dev/scarlett-jhbuild/beforeupgrade.sh \
#     --depends 'python2.7-dev' \
#     --depends 'python3.6-dev' \
#     -s dir \
#     -t deb \
#     jhbuild=/opt/scarlett-jhbuild \
#     .local=/opt/jhbuild

fpm --name $pkg_name \
    --version $pkg_version \
    --iteration ${pkg_release} \
    --architecture $pkg_arch \
    --after-install $HOME/dev/scarlett-jhbuild/scripts/afterinstall.sh \
    --before-install $HOME/dev/scarlett-jhbuild/scripts/beforeinstall.sh \
    --after-remove $HOME/dev/scarlett-jhbuild/scripts/afterremove.sh \
    --before-remove $HOME/dev/scarlett-jhbuild/scripts/beforeremove.sh \
    --after-upgrade $HOME/dev/scarlett-jhbuild/scripts/afterupgrade.sh \
    --before-upgrade $HOME/dev/scarlett-jhbuild/scripts/beforeupgrade.sh \
    --depends 'python2.7-dev' \
    --depends 'python3.6-dev' \
    --exclude *.py[co] \
    --exclude *__pycache__ \
    --exclude *.git \
    -s dir \
    -t deb \
    --verbose \
    jhbuild=/opt/scarlett-jhbuild \
    .local=/opt/jhbuild

# EG: jhbuild-scarlett-deps_1.0.0-1_amd64.deb
echo '[VERIFY DEB PACKAGE] --------------------------------------------------'
dpkg -c ${pkg_name}_${pkg_version}-${pkg_release}_${pkg_arch}.deb

popd
