#!/bin/bash

# ---------------------------------------------------------------------------- #
#                                   Constants                                  #
# ---------------------------------------------------------------------------- #

IGNORE_FILES=(__pycache__)

# ----------------------------------- Paths ---------------------------------- #
TEST_ENV="/home/c_byrne/projects/comfy-testing-environment"
COMFY_DIRNAME="ComfyUI"
CUSTOM_NODES_DIRNAME="custom_nodes"
THIS_SCRIPT_PATH=$(realpath $0)
THIS_SCRIPT_PARENT_DIR=$(dirname $THIS_SCRIPT_PATH)


# ---------------------------------------------------------------------------- #
#                                 Isolate Nodes                                #
# ---------------------------------------------------------------------------- #

CUSTOM_NODES_DIR_FULLPATH=$(find $TEST_ENV/$COMFY_DIRNAME -type d -name $CUSTOM_NODES_DIRNAME)
echo "Found custom_nodes dir: $CUSTOM_NODES_DIR_FULLPATH"
ls -a $CUSTOM_NODES_DIR_FULLPATH

# Get list of all custom node dirs
# EXCLUDE: Files in IGNORE_FILES constant, hidden files, .example files
CUSTOM_NODE_DIRS=$(find $CUSTOM_NODES_DIR_FULLPATH -mindepth 1 -maxdepth 1 -type d -not -name "${IGNORE_FILES[@]}" -not -name ".*" -not -name "*.example")
