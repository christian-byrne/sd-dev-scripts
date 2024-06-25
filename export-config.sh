#!/bin/bash

# Export all variables in CONFIG.sh to be available in the environment.
THIS_SCRIPT_PATH=$(realpath $0)
THIS_SCRIPT_PARENT_DIR=$(dirname $THIS_SCRIPT_PATH)
. $THIS_SCRIPT_PARENT_DIR/CONFIG.sh

# Export all variables in CONFIG.sh to be available in the environment.
export $(grep -v '^#' $THIS_SCRIPT_PARENT_DIR/CONFIG.sh | xargs)
