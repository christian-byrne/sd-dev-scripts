#!/usr/bin/env bash

# ---------------------------------------------------------------------------- #
#                                   Constants                                  #
# ---------------------------------------------------------------------------- #

THIS_SCRIPT_PATH=$(realpath $0)
THIS_SCRIPT_PARENT_DIR=$(dirname $THIS_SCRIPT_PATH)
. $THIS_SCRIPT_PARENT_DIR/CONFIG.sh

# ---------------------------------------------------------------------------- #
#                               Option Arguments                               #
# ---------------------------------------------------------------------------- #

# Check for --help or -h
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: export-ld-lib-path.sh"
    echo "       export-ld-lib-path.sh <python_version>"
    return 0
fi

# $1 is optional argument of python version
if [ -n "$1" ]; then
    VENV_PYTHON_VERSION=$1
fi

# ---------------------------------------------------------------------------- #

# Activate virtual environment, then add LD_LIBRARY_PATH to the environment.
export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH
