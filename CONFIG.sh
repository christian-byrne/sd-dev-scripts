#!/usr/bin/env bash

# ---------------------------------------------------------------------------- #
#                                  USER CONFIG                                 #
# ---------------------------------------------------------------------------- #

USER_PATH="/home/c_byrne"

# ---------------------------- Virtual Environment --------------------------- #
VIRTUAL_ENV_DIRNAME="venv"
VENV_PYTHON_VERSION="3.11"

# ---------------------------------- Browser --------------------------------- #
CHROME_LOGS_DIRNAME="comfy-dev-chrome-logs"
CHROME_PROFILE_NAME="Default"
DEVTOOLS_WINDOW_DEFAULT="console"

# ---------------------- Stable Diffusion WebUI Options ---------------------- #
STABLE_DIFFUSION_WEBUI_DIR="$USER_PATH/tools/sd/sd-interfaces/stable-diffusion-webui"
SD_WEBUI_STARTUP_DELAY="5.12"
SD_WEBUI_CLI_ARGS="--xformers --no-half-vae"
SD_WEBUI_INJECT_FILENAME="launch.py"

# ------------------------------- Comfy Options ------------------------------ #
COMFY_PORT="8188"
COMFY_STARTUP_DELAY="2.56"
COMFY_STARTUP_CLI_ARGS=""
TEST_ENV="$USER_PATH/projects/comfy-testing-environment"
COMFY_DIRNAME="ComfyUI"
CUSTOM_NODES_DIRNAME="custom_nodes"
COMFU_INJECT_FILENAME="main.py"

# ---------------------------- StableSwarm Options --------------------------- #
STABLESWARM_PORT="7801"
STABLESWARM_STARTUP_DELAY="2.56"
STABLESWARM_STARTUP_CLI_ARGS=""
STABLESWARM_DIRNAME="StableSwarm"
STABLESWARM_TEST_ENV="$USER_PATH/projects/stableswarm-testing-environment"
STABLESWARM_INJECT_FILENAME="launch-linux.sh"

# ---------------------------------- Logging --------------------------------- #
MAX_LOG_LINES=3000

# ---------------------- Ignore Custom Node Directories ---------------------- #
IGNORE_FILES=(__pycache__)

# -------------------- Deactivated Custom Nodes Directory -------------------- #
DEACTIVATED_NODES_DIRNAME="deactivated_nodes"

# ---------------------------- Default Model Path ---------------------------- #
SD15_DEFAULT_FILENAME="v1-5-pruned-emaonly.safetensors"


# ---------------------------------------------------------------------------- #
#                                  DONT CHANGE                                 #
# ---------------------------------------------------------------------------- #
SD_WEBUI_FULLPATH="$STABLE_DIFFUSION_WEBUI_DIR"
COMFY_DIR_FULLPATH=$(find $TEST_ENV -type d -name $COMFY_DIRNAME)
STABLESWARM_FULLPATH=$(find $STABLESWARM_TEST_ENV -type d -name $STABLESWARM_DIRNAME)

CUSTOM_NODES_DIR_FULLPATH="$COMFY_DIR_FULLPATH/$CUSTOM_NODES_DIRNAME"
DEACTIVATED_NODES_DIR_FULLPATH="$COMFY_DIR_FULLPATH/$DEACTIVATED_NODES_DIRNAME"

SD15_DEFAULT_MODEL_FULLPATH="$STABLE_DIFFUSION_WEBUI_DIR/models/$SD15_DEFAULT_FILENAME"

COMFY_OUTPUTS_DIR_FULLPATH="$COMFY_DIR_FULLPATH/outputs"
COMFY_INPUTS_DIR_FULLPATH="$COMFY_DIR_FULLPATH/inputs"