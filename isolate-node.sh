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
    echo "Usage: isolate-node.sh [custom_node_name]"
    echo "Move all custom nodes to a temporary directory, except the one specified."
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

echo "Found custom_nodes dir: $CUSTOM_NODES_DIR_FULLPATH"
ls $CUSTOM_NODES_DIR_FULLPATH

# Get list of all custom node dirs
# EXCLUDE: Files in IGNORE_FILES constant, hidden files, .example files
CUSTOM_NODE_DIRS=$(find $CUSTOM_NODES_DIR_FULLPATH -mindepth 1 -maxdepth 1 -type d -not -name "${IGNORE_FILES[@]}" -not -name ".*" -not -name "*.example" -not -name "$CUSTOM_NODE_NAME")

# Ensure deactivated_nodes dir exists.
if [ ! -d "$DEACTIVATED_NODES_DIR_FULLPATH" ]; then
    mkdir $DEACTIVATED_NODES_DIR_FULLPATH
fi

# Move all custom nodes to deactivated_nodes dir.
for NODE_DIR in $CUSTOM_NODE_DIRS; do
    mv $NODE_DIR $DEACTIVATED_NODES_DIR_FULLPATH
done

# Ensure CUSTOM_NODE_NAME wasn't moved.
if [ -d "$DEACTIVATED_NODES_DIR_FULLPATH/$CUSTOM_NODE_NAME" ]; then
    mv $DEACTIVATED_NODES_DIR_FULLPATH/$CUSTOM_NODE_NAME $CUSTOM_NODES_DIR_FULLPATH
fi

