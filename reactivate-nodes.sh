#!/bin/bash

# ---------------------------------------------------------------------------- #
#                                   Constants                                  #
# ---------------------------------------------------------------------------- #

THIS_SCRIPT_PATH=$(realpath $0)
THIS_SCRIPT_PARENT_DIR=$(dirname $THIS_SCRIPT_PATH)
. $THIS_SCRIPT_PARENT_DIR/CONFIG.sh

# ---------------------------------------------------------------------------- #
#                                    Options                                   #
# ---------------------------------------------------------------------------- #

# Check for --help or -h
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: reactivate-nodes.sh [custom_node_name]"
    echo "Move all deactivated nodes back to custom_nodes directory."
    echo "custom_node_name supports wildcards."
    echo "Temporary directory: $DEACTIVATED_NODES_DIR_FULLPATH"
    echo "Ignore files: ${IGNORE_FILES[@]}"
    echo "Script path: $(realpath $0)"
    exit 0
fi

# Set default fallback
CUSTOM_NODE_NAME=""
if [ -n "$1" ]; then
    CUSTOM_NODE_NAME=$1
fi

# ---------------------------------------------------------------------------- #
#                                 Isolate Nodes                                #
# ---------------------------------------------------------------------------- #

echo "Found deactivated nodes dir: $DEACTIVATED_NODES_DIR_FULLPATH"
ls $DEACTIVATED_NODES_DIR_FULLPATH

# Get list of all deactivated node dirs
# EXCLUDE: Files in IGNORE_FILES constant, hidden files, .example files, .log files
DEACTIVATED_NODE_DIRS=$(find $DEACTIVATED_NODES_DIR_FULLPATH -mindepth 1 -maxdepth 1 -type d -not -name "${IGNORE_FILES[@]}" -not -name ".*" -not -name "*.example" -not -name "*.log")

# Ensure custom_nodes dir exists.
if [ ! -d "$CUSTOM_NODES_DIR_FULLPATH" ]; then
    echo "Error: custom_nodes directory not found. Aborting." >&2
    exit 1
fi

# Ensure no dirs will be overwritten by moving deactivated nodes.
for NODE_DIR in $DEACTIVATED_NODE_DIRS; do
    if [ -d "$CUSTOM_NODES_DIR_FULLPATH/$(basename $NODE_DIR)" ]; then
        echo "Error: $NODE_DIR already exists in custom_nodes directory. Aborting." >&2
        exit 1
    fi
done

# Move all deactivated nodes to custom_nodes dir.
for NODE_DIR in $DEACTIVATED_NODE_DIRS; do
    mv $NODE_DIR $CUSTOM_NODES_DIR_FULLPATH
done

echo "custom_nodes:"
ls $CUSTOM_NODES_DIR_FULLPATH
