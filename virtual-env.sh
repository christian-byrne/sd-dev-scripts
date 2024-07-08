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
    echo "Usage: virtual-env.sh [python_version]"
    echo "Activate virtual environment and set LD_LIBRARY_PATH."
    echo "Options:"
    echo "-h, --help        Show this help message and exit"
    echo "python_version   Python version to use"
    exit 0
fi

# $1 is optional argument of python version
if [ -n "$1" ]; then
    VENV_PYTHON_VERSION=$1
fi

# ---------------------------------------------------------------------------- #
#                                 Start Script                                 #
# ---------------------------------------------------------------------------- #

# Activate virtual environment, then add LD_LIBRARY_PATH to the environment.
cd $TEST_ENV
source $VIRTUAL_ENV_DIRNAME/bin/activate
export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH

# Cd to ComfyUI directory and run main.py
COMFY_DIR_FULLPATH=$(find $TEST_ENV -type d -name $COMFY_DIRNAME)
cd $COMFY_DIR_FULLPATH
python main.py
