
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
    echo "Usage: comfy_custom_node_development.sh [custom_node_name]"
    echo "custom_node_name supports wildcards."
    echo "Script path: $THIS_SCRIPT_PATH"
    exit 0
fi

# Save all arguments in an array.
ARGS=("$@")

# ---------------------------------------------------------------------------- #
#                                 Start Script                                 #
# ---------------------------------------------------------------------------- #

# Activate virtual environment, then add LD_LIBRARY_PATH to the environment.
cd $TEST_ENV
source $VIRTUAL_ENV_DIRNAME/bin/activate
export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH

# Start ComfyUI, piping all arguments.
cd $COMFY_DIRNAME
python main.py "${ARGS[@]}"
