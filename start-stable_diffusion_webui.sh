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

USE_VIRTUALENV=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
		case $1 in
				-h|--help)
						echo "Usage: start-stable_diffusion_webui.sh"
						echo "Options:"
						echo "-h, --help        Show this help message and exit"
						echo "-v, --use-virtualenv        Use virtual environment"
						exit 0
						;;
				-v|--use-virtualenv)
						USE_VIRTUALENV=true
						;;
				*)
						echo "Unknown parameter passed: $1"
						exit 1
						;;
		esac
		shift
done


# ---------------------------------------------------------------------------- #

cd $STABLE_DIFFUSION_WEBUI_DIR

if [ "$USE_VIRTUALENV" = true ]; then
	source $VIRTUAL_ENV_DIRNAME/bin/activate
	export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH
	python launch.py $SD_WEBUI_CLI_ARGS
else
	export LD_LIBRARY_PATH=/usr/lib64/python$VENV_PYTHON_VERSION/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH
	python3 launch.py $SD_WEBUI_CLI_ARGS
fi

# sd() {
# 	cd $AUTOMATIC_DIR
# 	python launch.py --xformers --no-half-vae
# }