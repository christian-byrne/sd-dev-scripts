import os
import subprocess
import sys

USER_INPUT = {"Comment": "", "Parameters": ""}


def main():
    # Use directory of caller.
    cd = os.getcwd()

    if len(sys.argv) != 2:
        print("Usage: python edit_metadata.py <target_image>")
        sys.exit(1)

    target_image = os.path.join(cd, sys.argv[1])

    if not os.path.isfile(target_image):
        print("Target image not found")
        sys.exit(1)

    # edit metadata
    for key, value in USER_INPUT.items():
        subprocess.run(["exiftool", f"-{key}={value}", target_image])

    print("Metadata edited successfully")

    # preview metadata
    print("Previewing metadata...\n\n")
    subprocess.run(["exiftool", target_image])
    print()


if __name__ == "__main__":
    main()
