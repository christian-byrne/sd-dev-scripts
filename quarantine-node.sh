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

QUARANTINE_TARGETS=()
DEACTIVATE_ALL_NODES=false

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
        -c|--comfy-dir-path)
            COMFY_DIR_FULLPATH="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "Usage: isolate-node.sh [options] [custom_node_name]"
            echo "Move all custom nodes to a temporary directory, except the one specified."
            echo "Options:"
            echo "  -a, --all:              Deactivate all custom nodes."
            echo "  -d, --deactivate-dir:   Specify the directory to move custom nodes to."
            echo "  -c, --comfy-dir-path:   Specify the full path to the ComfyUI directory."
            echo "Temporary directory: $DEACTIVATED_NODES_DIR_FULLPATH"
            echo "Ignore files: ${IGNORE_FILES[@]}"
            echo "Script path: $(realpath $0)"
            exit 0
            ;;
        *)
            if [[ $key == -* ]]; then
                echo "Unknown option: $key"
                exit 1
            else
                QUARANTINE_TARGETS+=("$key")
                shift
            fi
            ;;
    esac
done


# ---------------------------------------------------------------------------- #
#                                 Isolate Nodes                                #
# ---------------------------------------------------------------------------- #

if [ $DEACTIVATE_ALL_NODES = true ]; then
    echo "Deactivating all custom nodes."
    # Use the isolate-node.sh with --all option to deactivate all nodes.
    bash $THIS_SCRIPT_PARENT_DIR/isolate-node.sh --all
    exit 0
fi

echo -e "\nFound custom_nodes dir: $CUSTOM_NODES_DIR_FULLPATH"
ls $CUSTOM_NODES_DIR_FULLPATH
echo -e "\n"

echo "Deactivated nodes dir: $DEACTIVATED_NODES_DIR_FULLPATH"
echo -e "\n"

# Ensure deactivated_nodes dir exists.
if [ ! -d "$DEACTIVATED_NODES_DIR_FULLPATH" ]; then
    mkdir $DEACTIVATED_NODES_DIR_FULLPATH
fi

# Ensure CUSTOM_NODE_NAME is in the custom_nodes dir.
if [ ! -d "$CUSTOM_NODES_DIR_FULLPATH/$CUSTOM_NODE_NAME" ]; then
    echo "Custom node not found: $CUSTOM_NODE_NAME"
    exit 1
fi

# Ensure will not overwrite a dir in deactivated_nodes.
if [ -d "$DEACTIVATED_NODES_DIR_FULLPATH/$CUSTOM_NODE_NAME" ]; then
    echo "Error: Custom node already in deactivated_nodes dir: $CUSTOM_NODE_NAME"
    exit 1
fi

# Move quarantined node to deactivated_nodes dir.
mv $CUSTOM_NODES_DIR_FULLPATH/$CUSTOM_NODE_NAME $DEACTIVATED_NODES_DIR_FULLPATH

