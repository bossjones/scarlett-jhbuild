#!/usr/bin/env bash
# SOURCE: https://unix.stackexchange.com/questions/36871/where-should-a-local-executable-be-placed

# -------------------------------------------------------------
# $HOME/bin Local binaries
# $HOME/etc Host-specific system configuration for local binaries
# $HOME/games Local game binaries
# $HOME/include Local C header files
# $HOME/lib Local libraries
# $HOME/lib64 Local 64-bit libraries
# $HOME/man Local online manuals
# $HOME/sbin Local system binaries
# $HOME/share Local architecture-independent hierarchy
# $HOME/src Local source code
# -------------------------------------------------------------

mkdir -p $HOME/bin
mkdir -p $HOME/etc
mkdir -p $HOME/games
mkdir -p $HOME/include
mkdir -p $HOME/lib
mkdir -p $HOME/lib64
mkdir -p $HOME/man
mkdir -p $HOME/sbin
mkdir -p $HOME/share
mkdir -p $HOME/src
