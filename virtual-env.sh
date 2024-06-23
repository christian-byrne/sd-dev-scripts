#!/bin/bash

# ---------------------------------------------------------------------------- #
#                                   Constants                                  #
# ---------------------------------------------------------------------------- #

VIRTUAL_ENV_DIRNAME="venv"
VENV_PYTHON_VERSION="3.11"

# ----------------------------------- Paths ---------------------------------- #
TEST_ENV="/home/c_byrne/projects/comfy-testing-environment"
COMFY_DIRNAME="ComfyUI"

# ---------------------------------------------------------------------------- #
#                               Option Arguments                               #
# ---------------------------------------------------------------------------- #

# Check for --help or -h
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: comfy_custom_node_development.sh [custom_node_name]"
    echo "custom_node_name supports wildcards."
    echo "Script path: $(realpath $0)"
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
