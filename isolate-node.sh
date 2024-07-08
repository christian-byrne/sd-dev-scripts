#!/usr/bin/env bash

# ---------------------------------------------------------------------------- #
#                                   Constants                                  #
# ---------------------------------------------------------------------------- #

THIS_SCRIPT_PATH=$(realpath $0)
THIS_SCRIPT_PARENT_DIR=$(dirname $THIS_SCRIPT_PATH)
. $THIS_SCRIPT_PARENT_DIR/CONFIG.sh

# ---------------------------------------------------------------------------- #
#                                    Options                                   #
# ---------------------------------------------------------------------------- #

DEACTIVATE_ALL_NODES=false
ISOLATED_NODE_NAMES=()
VERBOSE=false

# Parse options.
while [[ "$#" -gt 0 ]]; do
    key="$1"

    case $key in
        -a|--all)
            DEACTIVATE_ALL_NODES=true
            shift
            ;;
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
            echo -e "Move all custom nodes to a temporary directory, except the one specified.\n"
            echo "Usage: isolate-node.sh [options] node_name[, node_name, ...] "
            echo "Options:"
            echo "  -a, --all:              Deactivate all custom nodes."
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
            # Case for position required arguments.
            if [ "$key" == -* ]; then
                echo "Unknown option: $key"
                exit 1
            else
                ISOLATED_NODE_NAMES+=("$key")
                shift
            fi
            ;;
    esac
done

if [ ${#ISOLATED_NODE_NAMES[@]} -eq 0 ] && [ "$DEACTIVATE_ALL_NODES" = false ]; then
    echo "No custom node specified. To deactivate all nodes, use the -a option."
    exit 1
fi

# ---------------------------------------------------------------------------- #
#                                 Isolate Nodes                                #
# ---------------------------------------------------------------------------- #

# Ensure deactivated_nodes dir exists.
if [ ! -d "$DEACTIVATED_NODES_DIR_FULLPATH" ]; then
    mkdir $DEACTIVATED_NODES_DIR_FULLPATH
fi

if [ "$VERBOSE" = true ]; then
    echo -e "\nProcess Params:"
    echo "Deactivate all nodes: $DEACTIVATE_ALL_NODES"
    echo "Custom node names: ${ISOLATED_NODE_NAMES[@]}"
    echo "Deactivated nodes dir: $DEACTIVATED_NODES_DIR_FULLPATH"
    echo "Ignore files: ${IGNORE_FILES[@]}"
    echo -e "\n\nFound custom_nodes dir: $CUSTOM_NODES_DIR_FULLPATH"
    echo "Contents of custom_nodes dir:"
    ls $CUSTOM_NODES_DIR_FULLPATH
    echo -e "\n\nDeactivated nodes dir: $DEACTIVATED_NODES_DIR_FULLPATH"
    echo "Contents of deactivated_nodes dir:"
    ls $DEACTIVATED_NODES_DIR_FULLPATH
fi

# `find` will produce absolute paths if the starting directory is absolute. So ensure that it is.
if [ "${CUSTOM_NODES_DIR_FULLPATH:0:1}" != "/" ]; then
    if [ "$VERBOSE" = true ]; then
        echo -e "\nCustom Nodes Dir Fullpath was: $CUSTOM_NODES_DIR_FULLPATH"
        echo "Making it absolute..."
    fi
    CUSTOM_NODES_DIR_FULLPATH=$(realpath $CUSTOM_NODES_DIR_FULLPATH)
    if [ "$VERBOSE" = true ]; then
        echo -e "\nCustom Nodes Dir Fullpath is now: $CUSTOM_NODES_DIR_FULLPATH"
    fi
fi

# Convert ISOLATED_NODE_NAMES to a comma-separated string.
ISOLATED_NODE_NAMES_STRING=$(IFS=',' ; echo "${ISOLATED_NODE_NAMES[*]}")
if [ "$VERBOSE" = true ]; then
    echo -e "\nIsolated Node Names: $ISOLATED_NODE_NAMES_STRING"
fi

# Convert IGNORE_FILES to a comma-separated string.
IGNORE_FILES_STRING=$(IFS=',' ; echo "${IGNORE_FILES[*]}")

# Get list of all custom node dirs to move
# EXCLUDE: Files in IGNORE_FILES, hidden files, .example files, and directories listed in ISOLATED_NODE_NAMES
MOVE_NODE_DIRS=$(find "$CUSTOM_NODES_DIR_FULLPATH" -mindepth 1 -maxdepth 1 -type d \
                   ! -name ".*" \
                   ! -name "*.example" \
                   $(for ignore in "${IGNORE_FILES[@]}"; do echo ! -name "$ignore"; done) \
                   $(for node in "${ISOLATED_NODE_NAMES[@]}"; do echo ! -name "$node"; done))

# Move all custom nodes to deactivated_nodes dir.
for NODE_DIR in $MOVE_NODE_DIRS; do
    mv $NODE_DIR $DEACTIVATED_NODES_DIR_FULLPATH
done

# Ensure all the ISOALTED_NODE_NAMES weren't moved (still in the custom_nodes dir).
for NODE_NAME in ${ISOLATED_NODE_NAMES//,/ }; do
    # Check if in CUSTOM_NODES_DIR_FULLPATH
    if [[ ! -d "$CUSTOM_NODES_DIR_FULLPATH/$NODE_NAME" ]]; then
        # Check if in DEACTIVATED_NODES_DIR_FULLPATH
        if [[ -d "$DEACTIVATED_NODES_DIR_FULLPATH/$NODE_NAME" ]]; then
            # Move back to CUSTOM_NODES_DIR_FULLPATH
            if [ "$VERBOSE" = true ]; then
                echo "Error: $NODE_NAME was deactivated, moving back to $CUSTOM_NODES_DIR_FULLPATH"
                echo "Moving $NODE_NAME back to $CUSTOM_NODES_DIR_FULLPATH"
            fi
            mv $DEACTIVATED_NODES_DIR_FULLPATH/$NODE_NAME $CUSTOM_NODES_DIR_FULLPATH
        fi
    fi
done

