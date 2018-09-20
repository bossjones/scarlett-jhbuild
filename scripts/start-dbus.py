#!/usr/bin/env python

import os
import sys
import signal
import subprocess
import atexit
import warnings
import imp

# SOURCE: https://github.com/GNOME/pygobject/blob/e19934f2d348a3e358be50280ee73ee345682ed6/tests/__init__.py
def dbus_launch_session():
    if os.name == "nt" or sys.platform == "darwin":
        return (-1, "")

    # try:
    #     dbus_ensure = subprocess.check_output([
    #         "dbus-uuidgen", "--ensure"])
    # except (subprocess.CalledProcessError, OSError):
    #     return (-1, "")

    try:
        out = subprocess.check_output(
            ["dbus-daemon", "--session", "--fork", "--print-address=1", "--print-pid=1"]
        )
    except (subprocess.CalledProcessError, OSError):
        return (-1, "")
    else:
        if sys.version_info[0] == 3:
            out = out.decode("utf-8")
        addr, pid = out.splitlines()
        return int(pid), addr


pid, addr = dbus_launch_session()
if pid >= 0:
    os.environ["DBUS_SESSION_BUS_ADDRESS"] = addr
    os.environ["DBUS_SESSION_BUS_PID"] = pid
    # atexit.register(os.kill, pid, signal.SIGKILL)
else:
    os.environ["DBUS_SESSION_BUS_ADDRESS"] = "."

if __name__ == "__main__":
    dbus_launch_session()
