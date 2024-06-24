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

VERBOSE=false

# Parse options.
while [[ "$#" -gt 0 ]]; do
    key="$1"

    case $key in
        -d|--deactivate-dir)
            DIR_ARG="$2"
            if [ -z "$DIR_ARG" ]; then
                echo "No directory specified."
                exit 1
            fi
            if [ ! -d "$DIR_ARG" ]; then
                echo "Directory does not exist: $DIR_ARG"
                exit 1
            fi
            DEACTIVATED_NODES_DIR_FULLPATH="$DIR_ARG"
            shift
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -i|--ignore)
            IGNORE_FILES+=("$2")
            shift
            shift
            ;;
        -c|--comfy-dir-path)
            COMFY_DIR_FULLPATH="$2"
            shift
            shift
            ;;
        -h|--help)
            echo -e "Move all custom nodes in the deactivated_nodes directory to the custom_nodes directory.\n"
            echo "Usage: reactivate-nodes.sh [options]"
            echo "Options:"
            echo "  -c, --comfy-dir-path:   Specify the full path to the ComfyUI directory."
            echo "  -d, --deactivate-dir:   Specify a custom directory to move custom nodes to."
            echo "  -i, --ignore:           Specify a file to ignore when moving custom nodes."
            echo "  -v, --verbose:          Enable verbose output."
            echo ""
            echo "Temporary directory: $DEACTIVATED_NODES_DIR_FULLPATH"
            echo "Ignore files: ${IGNORE_FILES[@]}"
            echo "Script path: $(realpath $0)"
            exit 0
            ;;
        *) 
            if [[ $key == -* ]]; then
                echo "Unknown option: $key"
                exit 1
            fi
            ;;
    esac
done


# ---------------------------------------------------------------------------- #
#                               Reactivate Nodes                               #
# ---------------------------------------------------------------------------- #

if [ "$VERBOSE" = true ]; then
    echo -e "\nDeactivate all nodes: $DEACTIVATE_ALL_NODES"
    echo "Deactivate directory: $DEACTIVATED_NODES_DIR_FULLPATH"
    echo "ComfyUI directory: $COMFY_DIR_FULLPATH"
    echo "Ignore files: ${IGNORE_FILES[@]}"
    echo "Isolated node names: ${ISOLATED_NODE_NAMES[@]}"
    echo -e "\nFound deactivated nodes dir: $DEACTIVATED_NODES_DIR_FULLPATH"
    echo "Deactivated nodes dir contents:"
    ls $DEACTIVATED_NODES_DIR_FULLPATH
fi

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

if [ "$VERBOSE" = true ]; then
    echo -e "\nContents of custom_nodes after reactivation:"
    ls $CUSTOM_NODES_DIR_FULLPATH
fi
