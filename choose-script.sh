#!/bin/bash

# List all scripts in this dir, then present them as options to the user.
DIR_SCRIPTS=$(ls -1 | grep -E '\.sh$')

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