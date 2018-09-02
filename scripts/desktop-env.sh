#!/usr/bin/env bash

# SOURCE: https://dbus.freedesktop.org/doc/dbus-uuidgen.1.html
# SOURCE: https://github.com/linzhangru/dbus/blob/95af34cdb84b8f8eb402a9dd55fab99853e23c3f/test/test-dbus-daemon-fork.sh

# bionic uses this
# dbus-daemon --session --fork --print-address=1
# EG. unix:abstract=/tmp/dbus-7UUnS1uYZD,guid=a1171a62a615349b842d54325b8b3c98
# DBUS_SESSION_BUS_PID=$(echo $(pgrep -x dbus-daemon))
# DBUS_SESSION_BUS_ADDRESS=

print_dbus_env() {
    env | grep -i dbus
}

export LC_MESSAGES='C'
export G_DEBUG='fatal-warnings fatal-criticals'

export DBUS_DEBUG_OUTPUT=1
export workdir=/tmp

pgrep -x dbus-daemon
if [ "$?" = "0" ]
then
    echo dbus Deamon already running
    export DBUS_SESSION_BUS_ADDRESS="$(cat "$workdir"/sessionbus.address)"
    test -n "$DBUS_SESSION_BUS_ADDRESS"
    export DBUS_SESSION_BUS_PID="$(cat "$workdir"/sessionbus.pid)"
    print_dbus_env
    exit 0
else

    [[ -e '/var/lib/dbus/machine-id' ]] && dbus-uuidgen --ensure || true

    dbus-daemon --session --fork --print-address=8 --print-pid=9 \
        8>"$workdir/sessionbus.address" 9>"$workdir/sessionbus.pid"

    export DBUS_SESSION_BUS_ADDRESS="$(cat "$workdir"/sessionbus.address)"
    test -n "$DBUS_SESSION_BUS_ADDRESS"
    export DBUS_SESSION_BUS_PID="$(cat "$workdir"/sessionbus.pid)"
    print_dbus_env

fi

# SOURCE: https://stackoverflow.com/questions/38505266/how-to-set-the-enviroment-variables-of-the-session-dbus-when-starting-in-an-init

# echo "Starting desktop-env Deamon"
# if [ -e "/var/run/dbus/sessionbus.pid" ];then
#             DBUS_SESSION_BUS_PID=`cat /var/run/dbus/sessionbus.pid`
# fi

# if [ -e "/var/run/dbus/sessionbus.address" ];then
#             DBUS_SESSION_BUS_ADDRESS=`cat /var/run/dbus/sessionbus.address`
# fi
# # start the dbus as session bus and save the enviroment vars
# if [ -z ${DBUS_SESSION_BUS_PID+x} ];then
#         echo "start session dbus ..."
#         dbus-uuidgen --ensure
#         eval "export $(/usr/bin/dbus-launch)"
#         echo "${DBUS_SESSION_BUS_PID}">/var/run/dbus/sessionbus.pid
#         echo "${DBUS_SESSION_BUS_ADDRESS}">/var/run/dbus/sessionbus.address
#         echo session dbus runs now at pid="${DBUS_SESSION_BUS_PID}"
# else
#         echo session dbus runs at pid="${DBUS_SESSION_BUS_PID}"
#         eval `dbus-launch --sh-syntax`
# fi

# pgrep -x myApp
# if [ "$?" = "0" ]
# then
#     echo dbus Deamon already running
#     exit 1
# fi
# DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS} myApp -d
# echo myApp started successfully
