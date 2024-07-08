#!/usr/bin/env bash

THIS_DIR=$(dirname $0)
cd $THIS_DIR

# List all scripts in this dir, then present them as options to the user.
DIR_SCRIPTS=$(ls -1 | grep -E '\.sh$')

# If an argument is provided, use it as the index of the script to run.
if [ -n "$1" ]; then
    SCRIPTS=($DIR_SCRIPTS)
    SCRIPT=${SCRIPTS[$1]}
    if [ -z "$SCRIPT" ]; then
        echo "Invalid script index."
        # List valid script indices.
        echo "Valid script indices:"
        for i in $(seq 0 $((${#SCRIPTS[@]} - 1))); do
            echo "$i: ${SCRIPTS[$i]}"
        done
    fi
    echo "Running script: $SCRIPT"
    bash "$SCRIPT"
    exit 0
fi

if [ -z "$DIR_SCRIPTS" ]; then
    echo "No scripts found in the current directory."
    exit 1
fi

echo "Choose a script to run:"
select SCRIPT in $DIR_SCRIPTS; do
    if [ -n "$SCRIPT" ]; then
        break
    else
        echo "Invalid choice. Please try again."
    fi
done

echo "You chose: $SCRIPT"

# Get options for the script execution.
read -p "Enter any options for the script: " OPTIONS

# Run the selected script
bash "$SCRIPT" $OPTIONS