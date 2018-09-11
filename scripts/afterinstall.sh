#!/bin/sh
# # postinst script for scarlett-jhbuild
# #
# # see: dh_installdeb(1)

# set -e

# # summary of how this script can be called:
# #        * <postinst> `configure' <most-recently-configured-version>
# #        * <old-postinst> `abort-upgrade' <new version>
# #        * <conflictor's-postinst> `abort-remove' `in-favour' <package>
# #          <new-version>
# #        * <postinst> `abort-remove'
# #        * <deconfigured's-postinst> `abort-deconfigure' `in-favour'
# #          <failed-install-package> <version> `removing'
# #          <conflicting-package> <version>
# # for details, see http://www.debian.org/doc/debian-policy/ or
# # the debian-policy package


# case "$1" in
#     configure)
#         ldconfig
#     ;;

#     abort-upgrade|abort-remove|abort-deconfigure)
#     ;;

#     *)
#         echo "postinst called with unknown argument \`$1'" >&2
#         exit 1
#     ;;
# esac

# :65534:65534

mkdir -p /etc/scarlett-jhbuild
cat << EOF > /etc/scarlett-jhbuild/jhbuildrc
# -*- mode: python -*-
# -*- coding: utf-8 -*-
import os
prefix='/opt/scarlett-jhbuild/jhbuild'
checkoutroot='/opt/gnome'
modulesets_dir = prefix + '/modulesets'
# moduleset = 'scarlett-world-lean.modules'
moduleset = 'scarlett-apps-3.28.modules'
modules = [ 'python-365', 'glib', 'fribidi', 'gobject-introspection', 'gstreamer', 'gst-libav', 'gst-plugins-bad', 'gst-plugins-base', 'gst-plugins-good', 'gst-plugins-ugly', 'gst-python', 'gtk+-3', 'pycairo', 'pygobject' ]
module_mesonargs['gstreamer'] = '-Ddisable_gtkdoc=true -Dgtk_doc=false'
autogenargs='--disable-gtk-doc'
skip = [ "WebKit" ]
interact = False
makeargs = '-j4'
build_policy = 'updated-deps'
use_local_modulesets = True
os.environ['CFLAGS'] = '-fPIC -O0 -ggdb -fno-inline -fno-omit-frame-pointer'
# FIXME: Temp python -> python3
# os.environ['PYTHON'] = 'python'
os.environ['PYTHON'] = 'python3'
os.environ['GSTREAMER'] = '1.0'
os.environ['ENABLE_PYTHON3'] = 'yes'
os.environ['ENABLE_GTK'] = 'yes'
os.environ['PYTHON_VERSION'] = '3.6'
os.environ['MAKEFLAGS'] = '-j4'
os.environ['PREFIX'] = '/opt/scarlett-jhbuild/jhbuild'
os.environ['JHBUILD'] = '/opt/gnome'
os.environ['PATH'] = '/usr/lib/ccache:/opt/scarlett-jhbuild/jhbuild/bin:~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
os.environ['LD_LIBRARY_PATH'] = '/opt/scarlett-jhbuild/jhbuild/lib:/usr/lib'
os.environ['PYTHONPATH'] = '/opt/scarlett-jhbuild/jhbuild/lib/python3.6/site-packages'
os.environ['PKG_CONFIG_PATH'] = '/opt/scarlett-jhbuild/jhbuild/lib/pkgconfig:/opt/scarlett-jhbuild/jhbuild/share/pkgconfig:/usr/lib/pkgconfig'
# -------------------------------------------------
os.environ['XDG_DATA_DIRS'] = '/opt/scarlett-jhbuild/jhbuild/share:/usr/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop'
os.environ['XDG_CONFIG_DIRS'] = '/opt/scarlett-jhbuild/jhbuild/etc/xdg'
os.environ['CC'] = 'gcc'
os.environ['PROJECT_HOME'] = '/opt/scarlett-jhbuild/dev'
# os.environ['PYTHONSTARTUP'] = '/opt/scarlett-jhbuild/.pythonrc'
os.environ['GI_TYPELIB_PATH'] = '/opt/scarlett-jhbuild/jhbuild/lib/girepository-1.0'
EOF

echo '[CHOWN] nobody:nobody'
sudo chown -R 65534:65534 /opt/scarlett-jhbuild /opt/gnome /opt/jhbuild
