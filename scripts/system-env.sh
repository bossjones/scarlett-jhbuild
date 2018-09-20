#!/usr/bin/env bash
# Script which must be sourced to setup the development environment.

# This has to be the first command because BASH_SOURCE[0] gets changed.
SCRIPT=${BASH_SOURCE[0]:-$0}

[[ "${BASH_SOURCE[0]}" == "$0" ]] \
    && echo "This script should not be executed but sourced like:" \
    && echo "    $ source $0" \
    && echo \
    && exit 1


export CFLAGS='-fPIC -O0 -ggdb -fno-inline -fno-omit-frame-pointer'
# FIXME: Temp python -> python3
# export PYTHON=python'
export PYTHON='python3'
export GSTREAMER='1.0'
export ENABLE_PYTHON3='yes'
export ENABLE_GTK='yes'
export PYTHON_VERSION='3.6'
export MAKEFLAGS='-j4'
export CHECKOUTROOT="/opt/"
export PREFIX='/opt/scarlett-jhbuild/jhbuild'
export JHBUILD='/opt/gnome'
export PATH='/usr/lib/ccache:/opt/scarlett-jhbuild/jhbuild/bin:~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
export LD_LIBRARY_PATH='/opt/scarlett-jhbuild/jhbuild/lib:/usr/lib'
export PYTHONPATH='/opt/scarlett-jhbuild/jhbuild/lib/python3.6/site-packages'
export PKG_CONFIG_PATH='/opt/scarlett-jhbuild/jhbuild/lib/pkgconfig:/opt/scarlett-jhbuild/jhbuild/share/pkgconfig:/usr/lib/pkgconfig'
# -------------------------------------------------
export XDG_DATA_DIRS='/opt/scarlett-jhbuild/jhbuild/share:/usr/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop'
export XDG_CONFIG_DIRS='/opt/scarlett-jhbuild/jhbuild/etc/xdg'
export CC='gcc'
export PROJECT_HOME='/opt/scarlett-jhbuild/dev'
export GI_TYPELIB_PATH='/opt/scarlett-jhbuild/jhbuild/lib/girepository-1.0'



echo "===================================================================="
# echo '                     _      _   _          _ _     _           _ _     _ '
# echo '                    | |    | | | |        (_) |   | |         (_) |   | |'
# echo '  ___  ___ __ _ _ __| | ___| |_| |_ ______ _| |__ | |__  _   _ _| | __| |'
# echo ' / __|/ __/ _` | '__| |/ _ \ __| __|______| | '_ \| '_ \| | | | | |/ _` |'
# echo ' \__ \ (_| (_| | |  | |  __/ |_| |_       | | | | | |_) | |_| | | | (_| |'
# echo ' |___/\___\__,_|_|  |_|\___|\__|\__|      | |_| |_|_.__/ \__,_|_|_|\__,_|'
# echo '                                         _/ |                            '
# echo '                                        |__/                             '
echo "=======================[scarlett-jhbuild-system]===================="
echo "===================================================================="
echo "CFLAGS=${CFLAGS}"
echo "PYTHON=${PYTHON}"
echo "GSTREAMER=${GSTREAMER}"
echo "ENABLE_PYTHON3=${ENABLE_PYTHON3}"
echo "ENABLE_GTK=${ENABLE_GTK}"
echo "PYTHON_VERSION=${PYTHON_VERSION}"
echo "MAKEFLAGS=${MAKEFLAGS}"
echo "PREFIX=${PREFIX}"
echo "CHECKOUTROOT=${CHECKOUTROOT}"
echo "JHBUILD=${JHBUILD}"
echo "PATH=${PATH}"
echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
echo "PYTHONPATH=${PYTHONPATH}"
echo "PKG_CONFIG_PATH=${PKG_CONFIG_PATH}"
# -------------------------------------------------
echo "XDG_DATA_DIRS=${XDG_DATA_DIRS}"
echo "XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS}"
echo "CC=${CC}"
echo "PROJECT_HOME=${PROJECT_HOME}"
echo "GI_TYPELIB_PATH=${GI_TYPELIB_PATH}"
