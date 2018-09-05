#!/usr/bin/env python

# Copyright (c) 2008 Carnegie Mellon University.
#
# You may modify and redistribute this file under the same terms as
# the CMU Sphinx system. See LICENSE for more information.

import gi

gi.require_version("GLib", "2.0")
gi.require_version("Gtk", "3.0")
gi.require_version('Gst', '1.0')
from gi.repository import GObject
from gi.repository import Gst
from gi.repository import Gtk
GObject.threads_init()
Gst.init(None)

gst = Gst
