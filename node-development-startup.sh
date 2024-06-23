#!/bin/bash

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

# $1 is optional argument of custom node name
# Set default fallback
CUSTOM_NODE_NAME=""
if [ -n "$1" ]; then
    CUSTOM_NODE_NAME=$1
fi

# ---------------------------------------------------------------------------- #
#                                 Start Script                                 #
# ---------------------------------------------------------------------------- #

# Open separate terminal window in TEST_ENV
if ! command -v terminator &> /dev/null
then
    # Use default terminal if terminator is not installed
    gnome-terminal -- bash -c "cd $TEST_ENV/$COMFY_DIRNAME/$CUSTOM_NODES_DIRNAME/$CUSTOM_NODE_NAME;ls;bash"
else
    # Use terminator if it is installed
    terminator -e "cd $TEST_ENV/$COMFY_DIRNAME/$CUSTOM_NODES_DIRNAME/$CUSTOM_NODE_NAME;ls;bash"
fi

# Activate virtual environment, then add LD_LIBRARY_PATH to the environment.
cd $TEST_ENV
source $VIRTUAL_ENV_DIRNAME/bin/activate
export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH

# Set up logs.
CHROME_LOGS_PATH="$THIS_SCRIPT_PARENT_DIR/$CHROME_LOGS_DIRNAME/chrome.log"
touch $CHROME_LOGS_PATH
# Truncate the log file so it can't be longer than max size.
tail -n $MAX_LOG_LINES $CHROME_LOGS_PATH > $CHROME_LOGS_PATH 

# Function to start Chrome after a delay
start_chrome_after_delay() {
    sleep $COMFY_STARTUP_DELAY
    nohup google-chrome --profile-directory="$CHROME_PROFILE_NAME" --app="http://localhost:$COMFY_PORT" --auto-open-devtools-for-tabs --devtools-window="$DEVTOOLS_WINDOW_DEFAULT" --enable-logging --v=1
    # Open devtools using hotkey
    sleep .32
    xdotool key F12
}

# Make available in the subshell.
export CHROME_PROFILE_NAME
export CHROME_LOGS_PATH
export DEVTOOLS_WINDOW_DEFAULT
export COMFY_PORT
export COMFY_STARTUP_DELAY
export -f start_chrome_after_delay

# Start chrome using a default setting custom profile. Redirect stdout/err to log file. Disown the process.
nohup bash -c "start_chrome_after_delay" >> $CHROME_LOGS_PATH 2>&1 & disown

# Start ComfyUI.
cd $COMFY_DIRNAME
python main.py
